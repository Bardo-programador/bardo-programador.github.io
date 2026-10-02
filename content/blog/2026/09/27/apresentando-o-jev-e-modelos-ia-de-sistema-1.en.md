---
title: "Introducing Jev and System 1 AI Models"
date: 2026-09-27T17:11:19-03:00
slug: "introducing-jev-and-system-1-ai-models"
description: "An introduction to Jev and System 1 AI models: typed, structured decisions with high speed and calibrated confidence."
tags: ["tech", "daily-notes"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---

# About Jev
Jev is an AI model released on September 15, 2026 (just recently at the time of writing this article) by TypeSafe AI. The key characteristic of this model is that, unlike models from OpenAI, Claude, Gemini, etc., it is considered a System 1 class AI model.

# System 1, System 2?
Let me break down what these classes mean:

## System 1 
System 1 models are those that do not return responses in free-form text, but rather as **structured and typed decisions**—looking much like a JSON or structured document. Their main advantage is making decisions extremely fast and at low cost. You ask in natural language, for example, "is this transaction fraudulent?" and it returns something like:

```json
{
"choice" : "yes",
"confidence": 0.8
}
```

The decision along with the probability of it being right (which is another advantage). It doesn't just make the decision, but also provides the likelihood that it might be mistaken. It's worth noting that TypeSafe AI classifies it neither as an SLM (Small Language Model) nor an LLM (Large Language Model).


## System 2 
This is the class of systems we are accustomed to (ChatGPT, Claude, Gemini): you provide a prompt, and it returns a response in unstructured text. 

# Where should it be used?
Key use cases include:
- Real-time applications
- Classifiers
- AI-Powered Workflows
- Map-reducing over big data: Transforming petabytes of data into features and insights

# Jev Architecture 
Jev uses a training algorithm distinct from System 2 systems: it uses Reinforcement Learning for Calibrated Decisions (RLCD). The basic workflow of Jev follows this pipeline:

![screenshot_27 sep_17 54 29_23785](https://pub-9e61c7f76b8c4ef496ec79bc80204d16.r2.dev/screenshots/2026/09/2026-09-27-175640-screenshot_27-sep_17-54-29_23785.png)

1. The model receives a set of questions or prompts along with context from the system, program, or conversation.
2. It evaluates each question in parallel.
3. It returns the response with probabilities and question types.
4. Application code consumes this response to make a decision.

## TypeSafe Primitives
These are the possible response types. There are only 3:
1. Choice: An option from a predefined list
2. Score: The value of the question on a predefined scale (e.g., 0 to 10)
3. Bool: Used for binary yes/no answers

## Example of a structured instruction

```json
{
  "state": "My running shoes arrived in the wrong size. Can I swap them for a size 10?",
  "questions": {
    "department": {
      "type": "choice",
      "instructions": "Which team should handle this?",
      "criteria": {
        "returns": "Exchanges, wrong or damaged items",
        "shipping": "Delivery status, delays, lost packages",
        "billing": "Charges, invoices, payment problems"
      }
    }
  }
}
```

Here we have an example instruction: `"state"` is the provided context, and `"questions"` is the list of decisions for the model to make. Very straightforward—there is only one question:
*Which team should handle this?*

And the model must select one of the criteria:
`"returns"`, `"shipping"`, or `"billing"`.

A response would look like:
```json
{
  "model": "jev-1.13.0",
  "answers": {
    "department": {
      "type": "choice",
      "choice": "returns",
      "confidence": 1.0,
      "probabilities": {
        "shipping": 0.0,
        "returns": 1.0,
        "billing": 0.0
      }
    }
  },
  "usage": {
    "input_tokens": 328,
    "output_tokens": 34
  }
}
```

# Confidence vs. Probability
Jev relies on two important concepts:
- **Probability**: describes the likelihood that the model picks one of the options.
- **Confidence**: describes how confident the model is in its given response. It is derived from the probabilities. The more probability is concentrated on a single choice, the more "confident" it is in that choice.

# Open-Source Models

Currently, Jev is proprietary and available only via API. However, there are some open-source models you can run locally. The most prominent is [Laya](https://laya.convaiinnovations.com/). In general, it is faster than Jev simply because testing runs locally and without network latency—making Laya visibly faster.

However, there is an often-overlooked detail: in most cases, you will need to fine-tune Laya so it adapts properly to your specific problem.
