#import "@hugo/templates:0.1.0": article
#import "@hugo/utils:0.1.0": *

#show: article.with(
  title: "Hello, World!",
  date: datetime(year: 2026, month: 5, day: 10),
  weight: 0,
  tags: (
    platforms: ("hugo", "typst"),
    domains: "architecture",
    intents: ("introduction", "enhancement"),
  ),
  draft: false,
  references: ```yml
  typst-and-hugo:
    type: Blog
    title: "Typst and Hugo"
    author: George Honeywood
    date: 2023
    url:
      value: https://george.honeywood.org.uk/blog/typst-and-hugo/
      date: 2026-03-29
  ```,
)

= 前言

你好！我正在尝试使用 Typst 构建博客！

感谢 George Honeywood @typst-and-hugo 的分享和室友 #link("https://github.com/Vertsineu","@Vertsineu") 的帮助\~

#figure(
  caption: "你好，世界！",
  image("/images/helloworld.jpg"),
) <fig-maomao>