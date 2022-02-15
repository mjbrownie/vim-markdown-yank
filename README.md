# Markdown Yank

## About

I created this plugin to make it easy to do two things:

If you are in the `pwd` of an open source github/gitlab project...

1. yank and paste a formatted and syntax highlighted code block in a markdown document (eg vimwiki)
2. paste the formatted code block in an email / slack channel etc. (with links to the source code)

In addition to the yanked text adds:

1. a link to the source code web repository
2. a relative file location / line number to the source code (to work with `gF`)

## Screencast

![Screencast](https://mjbrownie.github.io/screencasts/markdown_yank.webm.gif)


## Setup

1. Install using your favorite vim package manager

2. Create a vmap eg.

```vim
vnoremap \my :call MarkdownCodeYank()<cr>
```

3. Go to an open source project directory

Eg. if you have neovim checked out...

```
michael@pop-os:~/github/neovim$ git remote -v
origin	https://github.com/neovim/neovim (fetch)
origin	https://github.com/neovim/neovim (push)
michael@pop-os:~/github/neovim$
```

1. Select a Code Segment in visual mode and use your vmap (eg, `\my` for the above mapping)

2. Navigate to your markdown notes file and paste.

It should paste (`p`) something like this...

```markdown

`src/nvim/main.c:202 - 209` [web](https://github.com/neovim/neovim/blob/master/src/nvim/main.c#L202-L209)

\`\`\`c
#ifdef MAKE_LIB
int nvim_main(int argc, char **argv);  // silence -Wmissing-prototypes
int nvim_main(int argc, char **argv)
#elif defined(WIN32)
int wmain(int argc, wchar_t **argv_w)  // multibyte args on Windows. #7060
#else
int main(int argc, char **argv)
#endif
\`\`\`

```

or as formatted ...

`src/nvim/main.c:202 - 209` [web](https://github.com/neovim/neovim/blob/master/src/nvim/main.c#L202-L209)

```c
#ifdef MAKE_LIB
int nvim_main(int argc, char **argv);  // silence -Wmissing-prototypes
int nvim_main(int argc, char **argv)
#elif defined(WIN32)
int wmain(int argc, wchar_t **argv_w)  // multibyte args on Windows. #7060
#else
int main(int argc, char **argv)
#endif
```

## Stuff that probably doesn't work yet...

* Unicode Names and weird characters. Please test and complain or pr.
* Note in this early version it currently clobbers the `"` and `+` registers
  with slightly different hadling of the `#` character. This is to make it
  easier to paste with `p` in vimwiki format and `<ctrl-v>` in a slack channel.
  but if you set up the default register to "+" then it will paste incorrectly.
* weird filetypes might need to be changed manually in source.

## TODO

* [ ] Add bitbucket support
* [ ] private repo / custom namespace support for (github/gitlab/bitbucket)

## Private Gitlab users

This is a quick rewrite of this gist I wrote to navigate through a large gitlab
namespaced project directory. If you are having trouble with this plugin
perhaps look at that.

Note the trick is to have your `~/Code/namespaced/project/structure/` arranged locally
in the same pattern as the gitlab project structure (ie not flat to ~/Code/<project>).

https://gist.github.com/mjbrownie/d537aa133a446ecc187064923aa3e1ff
