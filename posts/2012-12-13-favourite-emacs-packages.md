---
title: Favourite Emacs Packages
summary: List of my favourite Emacs packages: mu4e, projectile, powerline, twittering-mode and expand-region.
tags: emacs
keywords: emacs, mu4e, projectile, powerline, twittering-mode, expand-region
---

Recently my main development language switched from Python to Clojure. Emacs
being the most comprehensive IDE for Clojure made me replace my vimrc with an
emacs.d. In the meanwhile I have come across some great packages on Emacs
which I wanted to share with you. All the packages described below or
available on [Marmelade] or [Melpa] through the Emacs package.el.

[Marmelade]: http://marmalade-repo.org/
[Melpa]: http://melpa.milkbox.net/

## Mu4e

I tried a lot of email clients before finally coming across [mu4e]. [Sparrow]
made me use the mouse, Mutt didn't integrate with [org-mode], [Gnus] required
a 400 lines configuration and [Wanderlust] didn't work as I
wanted. 

<a class="colorbox" href="/images/posts/emacs-screenshot-mu4e.png" title="Emacs on Mu4e"><img src="/images/posts/emacs-screenshot-mu4e.png" /></a>

Mu4e seems to have exacly what I wanted in an email client. It required little
configuration, is very fast (search) and also allowed me to write and read
emails while offline.

[mu4e]: http://www.djcbsoftware.nl/code/mu/mu4e.html
[Sparrow]: http://www.sparrowmailapp.com/
[org-mode]: http://orgmode.org/
[Gnus]: http://www.gnus.org/
[Wanderlust]: http://www.gohome.org/wl/

## Projectile

[Projectile] is a libabry which helps you work with projects. I often want to
find a file inside the currently active project or maybe ack from the root of
the project. All this is possible by projectile.

You don't need to define your own projects manually, it looks at git,
mercuriaal or bazaar directories. My most used functions are
`projectile-find-file`, `projectile-ack`, `projectile-recentf` and
`projectile-dired`.

[Projectile]: https://github.com/bbatsov/projectile

## Powerline

Vim was the first to come out with a nicely formatted modebar called
[vim-powerline]. A few months later Emacs followed with
[emacs-powerline]. This package is mostly eye candy, benefit being that it
does give a better overview of you current Emacs
status.

[vim-powerline]: https://github.com/Lokaltog/vim-powerline
[emacs-powerline]: https://github.com/milkypostman/powerline

## Magit

[Magit] makes all Git features usable. Easily inspect the changes of a file
with a `<TAB>` and commit pick the parts you want to put in a commit. Using
`<TAB>` to inspect changes, `s` to stage and `x` for resetting the file to
most recent HEAD. A newly added mode is `magit-blame-mode` which intersects
your currently open buffer with the names of the people who are responsible
for changes.

[Magit]: http://philjackson.github.com/magit/

## Twittering mode

My colleagues laugh at me whenever they see how I use twitter and I must
admit, it does need some getting used to. But the moment you find out how
[Twittering mode] works, you become a Twitter powerhouse. Updating, replying and
retweeting with the press of a few buttons.

[Twittering mode]: http://twmode.sourceforge.net/

## Expand region

[Expand region] is from Magnar Sveen, the author of [Emacs Rocks] fame. It
allows you to expand a region by semantic units. You only need to keep
pressing the key until you get what you want. 

It's really useful for when you combine it with `pending-delete-mode`, which
replaces a selection when you start typing. I could try harder to explain what
it does, but [Episode 9] does it more justice.

[Expand region]: https://github.com/magnars/expand-region.el
[Emacs Rocks]: http://emacsrocks.com/
[Episode 9]: http://emacsrocks.com/e09.html

## Conclusion

Above packages really make a difference in my day-to-day Emacs usage. If you
want to see all the other packages I use, take a look at
[my dotfiles on Github]. Give a shout on twitter to [@wunki] about your own
favourite package.

[my dotfiles on Github]: https://github.com/wunki/wunki-dotfiles
[@wunki]: https://twitter.com/wunki

