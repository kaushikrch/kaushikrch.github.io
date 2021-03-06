library(knitr)

setwd("~/kaushikrch.github.io/_drafts/")
# Get the filename given as an argument in the shell.
args = "nsso-data-import.Rmd"
filename = args[1]

# Check that it's a .Rmd file.
if(!grepl(".Rmd", filename)) {
  stop("You must specify a .Rmd file.")
}

# Knit and place in _posts.
dir = paste0("../_posts/", Sys.Date(), "-")
output = paste0(dir, sub('.Rmd', '.md', filename))
knit(filename, output)

# Copy .png files to the images directory.
fromdir = "{{ site.url }}/images"
todir = "../images"

pics = list.files(fromdir, ".png")
pics = sapply(pics, function(x) paste(fromdir, x, sep="/"))
file.copy(pics, todir)
unlink("{{ site.url }}", recursive=T)
