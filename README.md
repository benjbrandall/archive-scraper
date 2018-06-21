# archive-scraper
Scrape and download Archive.org files from the command line with Ruby
archive-scraper

## Instructions

`git clone https://github.com/benjbrandall/archive-scraper.git`

`cd archive-scraper`

`bundle`

Find the ID of the collection you want to scrape files from. For example, the ID of the MIT Documents Library is `bitsavers_mit`. It's right there in the URL: https://archive.org/details/bitsavers_mit

Run:

`ruby scraper.rb`

When prompted, input the collection ID. This will fill your targets.txt file with the URLs of the different items in the collection.

Type in the file extension type you want to filter by when prompted (ex. zip, txt, torrent). archive-scraper will now go deeper into the page and pull out the direct download links for the collection's items.

When this is complete, you'll get the option to download the files to the program's `downloads` folder.

## Upcoming

* ~~The ability to supply the scraper with the URL of an entire collection and then scrape deeper into the collection to grab files.
*  ~~The option to use wget as part of the program, drawing from an output file of download URLs created while scraping.~~
