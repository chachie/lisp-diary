# lisp-diary: A simple flat file-formatted diary app.

The goal of `lisp-diary` is to simplify writing diary entries so that you spend less time learning a new tool, and more time writing your personal notes, or reminders and bits of information that have no home. This is achieved by using _one_ file with a simple format for _all_ your diary entries while leveraging your existing knowledge of Emacs. `lisp-diary` is not meant to produce a nicely formatted diary, or one that includes charts and pictures. Other specialized tools are more appropriate for these. You can however place links to the documents produced by these other tools within your diary entries.

Basically, `lisp-diary` allows you to write your diary in a Lisp file, which the app manages through a set of simple commands. 

A Lisp file is a file that contains code with valid Lisp syntax. The app defaults to the [Emacs Lisp](https://en.wikipedia.org/wiki/Emacs_Lisp) dialect.

> See [An Introduction to Programming in Emacs Lisp](https://www.gnu.org/software/emacs/manual/html_node/eintr/index.html) for a beginner's introduction to Elisp.

A typical diary entry consists of three sections, in the following order:

  * a date
  * a note inside double quotation marks `"..."`
    * a note can be any text
  * Lisp expressions

## Why use this format?

By using a Lisp file for your diary in Emacs, you can:

  * define reference mathematical formulas, that can be run within the buffer.
  * do quick calculations without opening a different window.
  * leverage other existing functions defined in Emacs.
  * get Lisp editing facilities (Emacs Lisp major mode):
    * code indentation
    * parameter hints as expressions are typed
    * code completion (C-M-i)

> See [Evaluating Emacs Lisp Expressions](https://www.gnu.org/software/emacs/manual/html_node/emacs/Lisp-Eval.html) for more info.

### Example ###

Let's assume you are planning to bake chocolate eclairs. You write down the recipe, which calls for 140 grams of flour. However, you need to make 4 times as much and you want the weight to be in ounces.

*You can write down the Lisp code to compute the new weight, and evaluate it right there to get the result, all without leaving your diary.*

You might also find out that you need to convert grams to ounces frequently.

*You can define a `grams-to-oz` function to reuse in difference places in the future.*


```elisp

;; Sat May 20 2023

"[baking] Chocolate eclairs: 140g flour, 125ml milk, 4 eggs"

(* 4 (* 140 0.035274)) ; 19.75344

(defun grams-to-oz (g) (* g 0.035274))

(grams-to-oz 140)

```

## Format of the diary file


```elisp
;;; diary.el --- diary w/ elisp -*- mode:emacs-lisp; -*-
;;; Commentary:

;;  Diary with elisp as a major mode.

;;; Code:
;; Sun May 21 2023
""
;; Sat May 20 2023
""
;; Fri May 19 2023
""
;; Thu May 18 2023
"TODO:
* ..."
(+ 1 1)

;;; diary.el ends here
```

# Tagging text in diary entries

You can tag text in a diary entry by writing a list of topics inside brackets. This makes searching through the diary easier using the **M-x topic-search** command.

For example, let's say you occasionally find nice articles to read. You can add a link to the article and tag it with `[article]` within your diary entry for the day.
Later, you can review the list of articles simply by doing a **M-x topic-search** with the word article. If you need to be more specific in your topic search, for example, looking only for coding related articles, then you can include that in the tag `[article coding]`.

# Basic workflow: #

  * Place the `lisp-diary.el` in your load path.
  * **M-x todays-notes**
      * This command takes you to the your diary file _at today's date_.
      * If your diary file is not set, it will prompt you to choose it.
  * **M-x add-days**
    * Because the app doesn't automatically insert new blank diary entries into the file, use this command to add as many such entries as you need.
  * **M-x topic-search**
    * This command will search text in your diary entries that you have tagged. Enter space delimited words to search for. The word order does not matter.
    * The more words you add, the more refined the search is. Note that you should already have the text tagged with all these words.
    * With a prefix **C-u M-x topic-search**, search directly in the buffer, rather than getting the search results in a separate buffer.
      * use **C-x z** to repeat the topic-search command
