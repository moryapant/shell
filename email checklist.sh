#!/bin/bash

# Customize these variables
folder="/path/to/log/files"  # Folder containing log files
email_to="recipient@example.com"  # Email recipient

# Create HTML table header
echo "<table border='1'>
       <tr>
         <th>Hostname</th>
         <th>Server Status</th>
       </tr>"

# Process log files
for file in "$folder"/*.log; do
  hostname=$(grep -oP 'hostname\s*\=\s*\K\w+' "$file")  # Extract hostname
  status=$(grep -oP 'status\s*\=\s*\K(connected|disconnected)' "$file")  # Extract status

  # Check if both hostname and status were found
  if [[ -n $hostname && -n $status ]]; then
    echo "<tr>
            <td>$hostname</td>
            <td>$status</td>
          </tr>"
  fi
done

echo "</table>"

# Send email using mailx or sendmail
mailx -a "Content-Type: text/html" -s "Server Status Report" "$email_to" < <(cat)  # Using mailx
# or
# sendmail -t -i < <(cat)  # Using sendmail
