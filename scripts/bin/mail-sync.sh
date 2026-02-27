#!/bin/sh

MBSYNC=$(pgrep mbsync)
NOTMUCH=$(pgrep notmuch)

if [ -n "$MBSYNC" ] || [ -n "$NOTMUCH" ]; then
	echo "Already running one instance of mbsync or notmuch. Exiting..."
	exit 0
fi

echo "Deleting messages tagged as *deleted*"
notmuch search --format=text0 --output=files tag:deleted | xargs -0 --no-run-if-empty rm -v

mbsync -a
notmuch new

echo "Notifying for new mail"
notmuch search --format=json +tag:unread date:30m.. |
	jq -r '.[]| .thread + "\n" + .authors + "\n" + .subject' |
	xargs --no-run-if-empty -d'\n' -n3 \
		sh -c 'notify-send -h "string:synchronous:$0" -u low -a Mail -i mail "$1" "$2"'
