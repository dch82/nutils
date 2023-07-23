# Contributing
## Making new commands
Follow [the guidelines](#command-guidelines) for commands, add it to `nutils.nu`, debug it and open up a PR!
## Command Guidelines
1. Try to implement the core of the program in pure Nushell; if it is too difficult, wrap it up.
2. If a simple Nushell pipeline can do what a dedicated *command/subcommand/option* could do, don't implement it; it's a waste of time and obsfucates help messages.
3. Don't bother implementing rarely-used *commands/subcommands/options*; see guideline 2
4. If possible, convert generic string output into a dedicated Nushell data type, e.g. `filesize`
5. Check if an already implemented [Nushell command](https://www.nushell.sh/commands/) or Nutils command does something similar enough.
