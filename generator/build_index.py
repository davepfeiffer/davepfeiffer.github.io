import argparse
import json

if __name__ == "__main__":

  parser = argparse.ArgumentParser(
      description="Adds post information to the site's index template")
  parser.add_argument('template', help="the path to the index template")
  parser.add_argument('output', default='index.md', nargs='?',
      help="the index filename to be written")
  parser.add_argument('--article_dir', default='articles',
      help="the path to the html web article outputs")
  args = parser.parse_args()

  index = None
  with open(args.template, 'r') as template:
    index = template.readlines()

  with open('./generator/article_registry.json', 'r') as registry:
    registry = json.loads(registry.read())

    articles = []
    for key, val in registry.items():
      articles.append(val)

    articles = sorted(articles, key=lambda x: x["DATE"], reverse=True)

    for art in articles:
      link = "* {} :: [{}]({})\n\n".format(
          art["DATE"], art["TITLE"], args.article_dir + '/' + art["PAGE"])
      index.append(link)

    index.append("</div></div>\n")

  with open('index.md', 'w') as file:
    file.writelines(index)