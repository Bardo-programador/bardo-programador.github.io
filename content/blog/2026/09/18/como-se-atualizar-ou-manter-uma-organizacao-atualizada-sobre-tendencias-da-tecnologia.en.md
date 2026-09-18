---
title: "How to stay updated or keep an organization updated on technology trends?"
date: 2026-09-18T17:02:51-03:00
slug: "how-to-stay-updated-or-keep-an-organization-updated-on-technology-trends"
description: "Learn about the Thoughtworks Technology Trends Radar."
tags: ["tech", "daily-notes"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---
The technology market tends to evolve very rapidly, and keeping up with it can be challenging. One effective way I found to stay up to date is by following the Thoughtworks Technology Radar.

# What is Thoughtworks?
It is a software consultancy and development company that provides consulting, training, and mentoring services in software engineering.

## The Thoughtworks Radar
Twice a year, Thoughtworks convenes a panel of senior engineers and developers to release a "radar" highlighting items of interest in technology. The radar evaluates tools, techniques, platforms, languages, and frameworks that are worth looking into, as well as those that might not be.\
Their radar is available (in both Portuguese and English) at [https://www.thoughtworks.com/radar](https://www.thoughtworks.com/radar).
![screenshot_18 sep_19 02 54_7857](https://pub-9e61c7f76b8c4ef496ec79bc80204d16.r2.dev/screenshots/2026/09/2026-09-18-190318-screenshot_18-sep_19-02-54_7857.png)

The radar is organized into 4 quadrants, categorized into the following rings:
- **Adopt**: Things that are strongly recommended for adoption across the organization and have been proven in production.
- **Trial**: Worth experimenting with on a project, though not as battle-tested.
- **Assess**: Worth looking into and exploring to understand how it might impact you.
- **Hold / Caution**: Proceed with caution; not necessarily bad, but potentially very new, undergoing major shifts, or leading teams into issues.


The 2026 radar looks like this:
![screenshot_18 sep_19 04 56_27290](https://pub-9e61c7f76b8c4ef496ec79bc80204d16.r2.dev/screenshots/2026/09/2026-09-18-190527-screenshot_18-sep_19-04-56_27290.png)
And further down, a table lists all the elements:
![screenshot_18 sep_19 06 22_7307](https://pub-9e61c7f76b8c4ef496ec79bc80204d16.r2.dev/screenshots/2026/09/2026-09-18-190635-screenshot_18-sep_19-06-22_7307.png)

And if you look closely at number 70, you'll spot it: [mise]({{< relref "como-instalar-qualquer-ferramenta-com-o-mise.en.md" >}}), so check it out if you haven't seen it yet.


# How to build your own radar?
They also provide the [source code](https://github.com/thoughtworks/build-your-own-radar) so you can build your own radar. The easiest way is to create a Google Sheet (or a raw CSV/JSON file) following this column structure:

| name          | ring    | quadrant               | isNew | description                                             |
| ------------- | ------- | ---------------------- | ----- | ------------------------------------------------------- |
| Composer      | adopt   | tools                  | TRUE  | Although the idea of dependency management ...          |
| Canary builds | trial   | techniques             | FALSE | Many projects have external code dependencies ...       |
| Apache Kylin  | assess  | platforms              | TRUE  | Apache Kylin is an open source analytics solution ...   |
| JSF           | Caution | languages & frameworks | FALSE | We continue to see teams run into trouble using JSF ... |

CSV format example:

```csv
name,ring,quadrant,isNew,description
Composer,adopt,tools,TRUE,"Although the idea of dependency management..."
Canary builds,trial,techniques,FALSE,"Many projects have external code dependencies..."
Apache Kylin,assess,platforms,TRUE,"Apache Kylin is an open source analytics solution..."
JSF,hold,languages & frameworks,FALSE,"We continue to see teams run into trouble using JSF..."
```

JSON format example:
```json
[
  {
    "name": "Composer",
    "ring": "adopt",
    "quadrant": "tools",
    "isNew": "TRUE",
    "description": "Although the idea of dependency management ..."
  },
  {
    "name": "Canary builds",
    "ring": "trial",
    "quadrant": "techniques",
    "isNew": "FALSE",
    "description": "Many projects have external code dependencies ..."
  },
  {
    "name": "Apache Kylin",
    "ring": "assess",
    "quadrant": "platforms",
    "isNew": "TRUE",
    "description": "Apache Kylin is an open source analytics solution ..."
  },
  {
    "name": "JSF",
    "ring": "Caution",
    "quadrant": "languages & frameworks",
    "isNew": "FALSE",
    "description": "We continue to see teams run into trouble using JSF ..."
  }
]
```
Afterwards, visit their [web page](https://radar.thoughtworks.com/), paste the file link into the input field, and click *Build my radar*. And that's it—you can view your own interactive radar and click *Print this radar* below to export it.

## Self-Hosted Version
If you want to host it on your own infrastructure, you can use the Docker version:

```bash
mkdir -p ./radar-files
docker run --rm -d --name tech-radar -p 8080:80 -e SERVER_NAMES="localhost 127.0.0.1" -v $(pwd)/radar-files:/opt/build-your-own-radar/files wwwthoughtworks/build-your-own-radar
```

This will create a `radar-files` directory in the current path and start the Docker container. Next, place your spreadsheet file inside `radar-files` (let's call it `radar.csv`). Open your browser at [http://localhost:8080](http://localhost:8080) and provide the link in the following format:
- `http://localhost:8080/files/radar.csv`

Replace `radar.csv` with your file's name, and you're set!

![screenshot_18 sep_18 34 30_7726](https://pub-9e61c7f76b8c4ef496ec79bc80204d16.r2.dev/screenshots/2026/09/2026-09-18-183457-screenshot_18-sep_18-34-30_7726.png)

If you prefer, here is the Docker Compose version:

```yaml
services:
  tech-radar:
    image: wwwthoughtworks/build-your-own-radar:latest
    container_name: tech-radar
    ports:
      - "8080:80"
    environment:
      - SERVER_NAMES=localhost 127.0.0.1
    volumes:
      - ./radar-files:/opt/build-your-own-radar/files:ro
    restart: unless-stopped
```
