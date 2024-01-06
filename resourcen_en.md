---
layout: post
title: Parenting Resources
comments: true
lang: en
permalink: /resourcen/
---
Welcome to our parenting resources. Here we collect links to websites that we think are helpful. 
So far we collected {{ site.data.resources | size }}. If you know of a website that is missing here, please write to us [via our contact form](/contact) or join [our Slack chat](/pages/slack).

### Categories

{% assign sortedItems = site.data.resource_categories | sort: "title_en" %}

<ul>
{% for category in sortedItems %}
  <li>
    <a href="/resourcen/{{ category.id }}">
      {{ category.title_en }}
    </a>
    <p>
    {{ category.description_en }}
    </p>
  </li>
{% endfor %}
</ul>
