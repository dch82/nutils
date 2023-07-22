#!/usr/bin/env nu

# Show filesystem disk space usage.
def df [
  --all (-a)    # Show all filesystems
] {
  let args = (if $all { "-aB1" } else { "-B1" })                                                                  # If --all is set, pass -aB1 to df; else pass -B1 to df
  let pre_convert = (run-external "df" $args --redirect-stdout | jc --df -r | from json)                          # Convert df output to nushell-friendly output
  let size = ($pre_convert | get 1b_blocks | into filesize  | wrap size)                                          # Convert df output size column to filesize format
  let used = ($pre_convert | get used | into filesize | wrap used )                                               # Convert df output used column to filesize format
  let available = ($pre_convert | get available | into filesize | wrap available )                                # Convert df output available column to filesize format
  $pre_convert | reject 1b_blocks | reject used | reject available | merge $size | merge $used | merge $available # Reject old size, used and available columns and merge new columns
}

# ls -r replacement
# Recommended usage: pipe into `table -e`
def lsr [
  dir = "."         # Directory to start in
] {
  cd $dir                                                                                       # Go into $dir
  ls | select name | merge (ls | get name | par-each { |item| cd $item; lsr } | wrap contents)  # List filenames and list directory contents, then repeat
}

# Show who is logged on
def who [] {
  let pre_convert = (run-external "who" --redirect-stdout | jc --who | from json)
  let time = ($pre_convert | get time | into datetime | wrap time)
  let epoch = ($pre_convert | get epoch | into datetime | wrap epoch)
  $pre_convert | reject time | reject epoch | merge $time | merge $epoch
}
