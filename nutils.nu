#!/usr/bin/env nu

# Show filesystem disk space usage of {{file}}.
def df [        # Code shared by @fdncred
  file = ""
  --all (-a)    # Show all filesystems
] {
  let args = (if $all { "-aB1" } else { "-B1" })        # If --all is set, pass -aB1 to df; else pass -B1 to df
  run-external "df" $args --redirect-stdout |                                                                            
  str replace "Mounted on" "Mountpoint" |               
  detect columns |                                      
  rename filesystem size used avail used% mountpoint |  
  into filesize size used avail |                       
  upsert used% {|r| 100 * (1 - $r.avail / $r.size)}     
}

# ls -r replacement
# Recommended usage: pipe into `table -e`
def lsr [
  dir = "."         # Directory to start in
] {
  cd $dir                                                                                       # Go into $dir
  ls |
  select name |
  merge (   
    ls |
    get name |
    par-each {
      |item|
      cd $item;
      lsr
    } |
    wrap contents
  )
}

# Show who is logged on
def who [     # Shared by @amotine
  --all (-a)  # Show all details
] {
  let args = ( if $all { "-aHu" } else { "-Hu" })
  run-external "who" $args --redirect-stdout | detect columns | rename name tty date idle pid comment exit | into datetime date
}
