#!/bin/sh

#
# This script scraps some pokémon pictures from Bulbapedia.
#

bulbapedia_page_url="http://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_National_Pok%C3%A9dex_number"
bulbapedia_page_name="bulbapedia.html"
images_folder="`pwd`/images"

# Make sure the directory for the scrapped data is there.
mkdir -p "$images_folder"

# Download the bulbapedia page if it doesn't already.
if [ ! -e "images/bulbapedia.html" ]; then
	echo "  > Downloading '$bulbapedia_page_url' to '$images_folder/$bulbapedia_page_name' ..."
	wget "$bulbapedia_page_url" -O "$images_folder/$bulbapedia_page_name" -q
	echo "  > Downloaded."
fi

## Perl RegExp parses the name of the Pokemon then grabs the dowload url for the image.

pokemon_images="$( cat "$images_folder/$bulbapedia_page_name" | perl -ne 'print "$1=http:$2\n" if m{.*<img alt="(.*)" src="(//cdn.bulbagarden.net/upload/.*\.png)" width="40" height="40"\s*/>.*$}')"
echo "$pokemon_images"
for line in $pokemon_images; do
	pokemon_name="${line%=*}"
	pokemon_url="${line#*=}"

	# Unescape HTML characters... Damn "Farfetch&#39;d".
	pokemon_name=$(echo "$pokemon_name" | sed "s/&#38;/'/")

	# If wget is interrupted by a SIGINT or something, it will
	# leave a broken file. Let's remove it and exit in case we
	# receive a signal like this.
	# Signals: (1) SIGHUP; (2) SIGINT; (15) SIGTERM.
	trap "rm $scrap_folder/$pokemon_name.png; echo Download of $pokemon_name was cancelled; exit" 1 2 15

	echo "  > Downloading '$pokemon_name' from '$pokemon_url' to '$scrap_folder/$pokemon_name.png' ..."
	wget "$pokemon_url" -O "$images_folder/$pokemon_name.png" -q
	echo "  > Converting '$pokemon_name' from '$pokemon_url' to '$scrap_folder/$pokemon_name.png' ..."
    convert -trim "$images_folder/$pokemon_name.png" "$images_folder/$pokemon_name.png"
    convert -flop "$images_folder/$pokemon_name.png" "$images_folder/$pokemon_name.png"
done
