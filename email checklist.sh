#!/bin/bash

# Set the email address to which the report will be sent
TO_EMAIL="your@email.com"

# Array of log files for each server
LOG_FILES=(
    "/path/to/server1.log"
    "/path/to/server2.log"
    "/path/to/server3.log"
    # Add more log files as needed
)

# Function to generate HTML table for a given log file
generate_html_table() {
    local log_file="$1"
    echo "<html><head><style>table {border-collapse: collapse; width: 100%;} th, td {border: 1px solid black; padding: 8px; text-align: left;} th {background-color: #f2f2f2;}</style></head><body><table>"
    echo "<tr><th>Hostname</th><th>Server Status</th><th>Connection Status</th></tr>"
    while read -r line; do
        echo "<tr><td>${line}</td><td>Running</td><td>Connected</td></tr>"
    done < "${log_file}"
    echo "</table></body></html>"
}

# Loop through each log file and send an email
for log_file in "${LOG_FILES[@]}"; do
    HTML_CONTENT=$(generate_html_table "${log_file}")
    (echo -e "Content-type: text/html\nSubject: Server Status Report - $(basename "${log_file}")\n"; echo "${HTML_CONTENT}") | /usr/sbin/sendmail -t "${TO_EMAIL}"
    echo "Email sent for $(basename "${log_file}")"
done

echo "All emails sent successfully!"
