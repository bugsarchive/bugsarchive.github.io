# [BugsArchive](https://bugs.lewoof.xyz) - The Compendium of Computer Science

BugsArchive is a compendium of anything related to computer science or software engineering at all levels of abstractions.
It's a pretty simple site but can be extremely useful for teaching things or revising your own knowledge.

Before explaining the project structure, here are some rules for those looking to submit articles or code changes:

## A few rules

1. Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) on your commit messages.
2. No JS unless absolutely necessary. We want this to be accessible by the simplest of browsers, including terminal ones.
3. Anything created for this project must be FOSS.
4. No shitposting in PRs, and no special characters, shell escape characters or RegEx syntax in directory or file names.
5. No AI generated content nor plagiarised content. All content must be written by humans and be original; cite any sources however you want.

> [!WARNING]
> Violation of Rule 4 will cause you to no longer be able to contribute to the project whatsoever.

## Project Structure

The project structure so far, which is not the final and can be changed after discussions regarding how it should be structured, is a bunch of HTML pages generated from a shell script.

The articles are written in markdown and pushed to <https://github.com/bugsarchive/md>.

We then trigger an action in <https://github.com/bugsarchive/site> that runs the build script. The build script does the following:

- Clones the [md repository](https://github.com/bugsarchive/md).
- Loops over every category, writes a heading and starts a list for the category in `index.html`, and creates `<category>/index.html` based on the `main.md` under the category's directory.
  - Loops over every file in the category and lists them in `<category>/index.html` and `index.html`.
    - Generates an HTML for the article with `md2html`.
    - Does a search and replace with `sed` to title the generated HTML files for each article under a category.
- Runs `prettier` over all the built files for formatting.

You can read the build script yourself [here](https://github.com/bugsarchive/bugsarchive.github.io/blob/main/scripts/build.sh).

The files in `/src/` are used in a particular way to generate the HTML pages talked about in the description of the build script's function:

```
/build/index.html = /src/top.html + (generated list) + /src/btm.html
/build/category001/index.html = /src/cattop.html + (rendered main.md + generated list) + /src/catbtm.html
/build/category001/article001.html = /src/posttop.html + (rendered markdown) + /src/postbtm.html
```

Notice how none of the data has to be put together in the frontend, this is very important, we want the site to be accessible by the most simplest forms of browsers without any form of script support needed.
