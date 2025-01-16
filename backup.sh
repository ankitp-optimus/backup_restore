#!/bin/bash


usage() {
    echo "Usage: $0 <file_or_directory_path>"
    exit 1
}


if [ -z "$1" ]; then
    usage
fi

SOURCE=$1


if [ ! -e "$SOURCE" ]; then
    echo "Error: Source $SOURCE does not exist."
    exit 1
fi


BACKUP_DIR="./backup"
mkdir -p "$BACKUP_DIR"


TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BASENAME=$(basename "$SOURCE")
VERSION_FILE="$BACKUP_DIR/$BASENAME.versions"


if [ -f "$VERSION_FILE" ]; then
    VERSION=$(($(tail -1 "$VERSION_FILE" | awk -F, '{print $1}') + 1))
else
    VERSION=1
fi


BACKUP_NAME="$BASENAME-v$VERSION-$TIMESTAMP.tar.gz"


tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$(dirname "$SOURCE")" "$BASENAME"


echo "$VERSION,$TIMESTAMP,$BACKUP_NAME,$SOURCE" >> "$VERSION_FILE"

echo "Backup completed successfully: $BACKUP_DIR/$BACKUP_NAME"
