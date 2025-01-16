#!/bin/bash


usage() {
    echo "Usage: $0 <file_or_directory_name> [<version_number>]"
    exit 1
}


if [ -z "$1" ]; then
    usage
fi

BASENAME=$1
VERSION=$2
BACKUP_DIR="./backup"
VERSION_FILE="$BACKUP_DIR/$BASENAME.versions"


if [ ! -f "$VERSION_FILE" ]; then
    echo "Error: No backups found for $BASENAME."
    exit 1
fi


if [ -z "$VERSION" ]; then
    BACKUP_ENTRY=$(tail -1 "$VERSION_FILE")
else
    BACKUP_ENTRY=$(grep "^$VERSION," "$VERSION_FILE")
    if [ -z "$BACKUP_ENTRY" ]; then
        echo "Error: Version $VERSION not found for $BASENAME."
        exit 1
    fi
fi


BACKUP_NAME=$(echo "$BACKUP_ENTRY" | awk -F, '{print $3}')
ORIGINAL_PATH=$(echo "$BACKUP_ENTRY" | awk -F, '{print $4}')
BACKUP_FILE="$BACKUP_DIR/$BACKUP_NAME"


if [ ! -f "$BACKUP_FILE" ]; then
    echo "Error: Backup file $BACKUP_FILE not found."
    exit 1
fi


if [ -d "$(dirname "$ORIGINAL_PATH")" ]; then
    tar -xzf "$BACKUP_FILE" -C "$(dirname "$ORIGINAL_PATH")"
    echo "Restore completed successfully to: $ORIGINAL_PATH"
else
    echo "Error: Original directory does not exist: $(dirname "$ORIGINAL_PATH")"
    exit 1
fi
