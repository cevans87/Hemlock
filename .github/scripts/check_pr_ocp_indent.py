#!/usr/bin/env python3.8

from __future__ import annotations
from asyncio import gather, run
from asyncio.subprocess import create_subprocess_exec, PIPE, STDOUT
from dataclasses import dataclass
import logging
from pathlib import Path
import re
import sys
from typing import List, Pattern, Text, Tuple


log = logging.getLogger(__name__)
stream_handler = logging.StreamHandler(sys.stdout)
stream_handler.setLevel(logging.INFO)
log.setLevel(logging.INFO)
log.addHandler(stream_handler)


@dataclass(frozen=True)
class Hunk:
    start: int
    stop: int

    # "git diff -U0" has the following predictable pattern for hunk headers. It shows exactly where
    # a change starts and if any additional lines were changed after that, how many.
    _header_pattern: Pattern = re.compile(r'^@@.*\+(?P<start>\d+),?(?P<delta>\d+)? @@.*$')

    @staticmethod
    async def from_path(path: Path, /) -> Tuple[Hunk]:
        """Return Tuple[Hunk] of with start and stop of hunks changed since repo's master branch."""

        cmd = f'git diff origin/master -U0 {path}'
        proc = await create_subprocess_exec(*cmd.split(), stdout=PIPE)
        lines = tuple((await proc.communicate())[0].decode().splitlines())
        assert proc.returncode == 0

        hunks: List[Hunk] = []
        for line in lines:
            if match := Hunk._header_pattern.match(line):
                start = int(match.groupdict()['start'])
                stop = start + int(match.groupdict()['delta'] or '0')
                hunks.append(Hunk(start, stop))
        hunks: Tuple[Hunk] = tuple(hunks)
        
        return hunks


@dataclass(frozen=True)
class File:
    diff_text: Text

    @staticmethod
    async def from_path(path: Path, /) -> File:
        """Return File with diff-text suggested by ocp-indent."""

        bytes_ = path.read_bytes()
        hunks = await Hunk.from_path(path)
        for hunk in hunks:
            cmd = f'opam exec -- ocp-indent --lines={hunk.start}-{hunk.stop}'
            proc = await create_subprocess_exec(*cmd.split(), stdin=PIPE, stdout=PIPE)
            bytes_ = (await proc.communicate(bytes_))[0]
            await proc.wait()
            assert proc.returncode == 0, cmd

        cmd = f'diff -u {path} -'
        proc = await create_subprocess_exec(*cmd.split(), stdin=PIPE, stdout=PIPE)
        diff_text = (await proc.communicate(bytes_))[0].decode().strip()
        await proc.wait()
        #assert proc.returncode == 0, cmd

        return File(diff_text=diff_text)


@dataclass(frozen=True)
class Repo:
    diff_text: Text

    @staticmethod
    async def from_env() -> Repo:
        """Return Repo with diff text suggested by ocp-indent."""

        # Base path of repo is needed to construct absolute paths for changed OCaml files.
        cmd = 'git rev-parse --show-toplevel'
        proc = await create_subprocess_exec(*cmd.split(), stdout=PIPE)
        base_path = Path((await proc.communicate())[0].decode().strip())
        await proc.wait()
        assert proc.returncode == 0, cmd

        # Fetch master for comparison.
        cmd = 'git fetch origin master'
        proc = await create_subprocess_exec(*cmd.split(), stdout=PIPE, stderr=STDOUT)
        log.debug((await proc.communicate())[0].decode())
        await proc.wait()
        assert proc.returncode == 0, cmd

        # Names of files changed since master.
        cmd = 'git diff --name-only origin/master'
        proc = await create_subprocess_exec(*cmd.split(), stdout=PIPE)
        lines = (await proc.communicate())[0].decode().strip().splitlines()
        assert proc.returncode == 0, cmd

        # Absolute paths of all OCaml files changed since master.
        paths = tuple(
            path for path in [base_path / Path(line) for line in lines]
            if path.suffix in {'.ml', '.mli'}
        )

        # FIXME bad comment
        # OCaml files with original text, indented text, and diff text.
        files = tuple(await gather(*[File.from_path(path) for path in paths]))

        # Combined diff text of all changed OCaml files.
        diff_text = '\n\n'.join(file.diff_text for file in files if file.diff_text)

        return Repo(diff_text=diff_text)
    

def main() -> int:
    async def main_inner() -> int:
        cmd = f'opam install ocp-indent'
        proc = await create_subprocess_exec(*cmd.split(), stdout=PIPE, stderr=STDOUT)
        log.debug((await proc.communicate())[0].decode())
        await proc.wait()
        assert proc.returncode == 0, cmd

        ocp_indent = await Repo.from_env()

        if ocp_indent.diff_text:
            log.error(f'ocp-indent suggests the following edits:\n\n{ocp_indent.diff_text}')
            return 1

        return 0
        
    return run(main_inner())


if __name__ == '__main__':
    sys.exit(main())
