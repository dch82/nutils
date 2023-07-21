#!/usr/bin/env nu

# Show filesystem disk space usage.
def df [
  --all (-a)  # Show all filesystems
] {
  if $all {
    let size = (^df -a -B 1 | jc --df -r | from json | get 1b_blocks | each { |item| into filesize } | wrap size)
    let used = (^df -a -B 1 | jc --df -r | from json | get used | each { |item| into filesize } | wrap used )
    let available = (^df -a -B 1 | jc --df -r | from json | get available | each { |item| into filesize } | wrap available )
    ^df -a -B 1 | jc --df -r | from json | reject 1b_blocks | reject used | reject available | merge $size | merge $used | merge $available
  } else {
    let size = (^df -B 1 | jc --df -r | from json | get 1b_blocks | each { |item| into filesize } | wrap size)
    let used = (^df -B 1 | jc --df -r | from json | get used | each { |item| into filesize } | wrap used )
    let available = (^df -B 1 | jc --df -r | from json | get available | each { |item| into filesize } | wrap available )
    ^df -B 1 | jc --df -r | from json | reject 1b_blocks | reject used | reject available | merge $size | merge $used | merge $available
  }
}
