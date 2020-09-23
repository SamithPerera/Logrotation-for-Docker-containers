FROM ubuntu:latest

RUN apt-get update && apt-get -y install cron

# Copy hello-cron file to the cron.d directory
COPY ./cron/crontab /etc/cron.d/log-backup
COPY ./scripts/log-backup.sh /tmp/log-backup.sh

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/log-backup
RUN chmod 0777 /tmp/log-backup.sh

# Apply cron job
RUN crontab /etc/cron.d/log-backup

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log  
