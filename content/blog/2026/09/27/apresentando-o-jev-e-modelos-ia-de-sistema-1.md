---
title: "Apresentando o Jev e modelos IA de Sistema 1"
date: 2026-09-27T17:11:19-03:00
slug: "apresentando-o-jev-e-modelos-ia-de-sistema-1"
description: "Descrição breve do post para SEO e listagem."
tags: ["tech", "dia-a-dia"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---

# Sobre o Jev
Jev é um modelo de IA lançado no dia 15 de setembro de 2026 (agorinha a pouco no tempo desde artigo) pela TypeSafe IA. A principal peculiaridade desse modelo é que diferente de modelos como da OpenIA, Claude, Gemini, etc, ele é considerado um modelo de IA de classe Sistema 1.

# Sistema 1, 2?
Preciso aqui dar uma explicação do que se trata essas classes:

## Sistema tipo 1 
Modelos de Sistema 1 são aqueles que não devolvem uma resposta em texto, mas sim **decisões estruturadas e tipadas**. Parecendo um JSON ou documento mesmo. A principal vantagem dele é para decidir algo extremente rápido e com baixo custo, você pergunta para em linguagem natural, por exemplo, "essa transação é fraudulenta?" e ele devolve algo como:

```json
{
"choice" : "yes",
"confidence": 0.8
}
```

A decisão e probabilidade dela está certa(o que é outra vantagem). Ele não só faz a decisão, mas também dá a chance dele está falando besteira. É importante salientar que a TypeSafe IA não classifica ele como um SLM(Small Language Model) nem LLM (Large).


## Sistema tipo 2 
É a classe dos sistemas que conhecemos normalmente(ChatGPT, Claude, Gemini), você faz um prompt e ele devolve a resposta em texto não estruturado. 

# Onde ele deve ser usado?
Os principais casos de usos incluem:
- Aplicações em tempo real
- Classificadores
- AI-Powered Workflows
- Map-reducing over big data: Transforma petabytes de dados em features e insights
# Arquitetura do Jev 
O Jev usa um algoritmo de treinamento diferente dos Sistemas tipo 2, ele usa Reinforcement Learning for Calibrated Decisions (RLCD). O funcionamento básico do Jev segue este fluxo:

![screenshot_27 sep_17 54 29_23785](https://pub-9e61c7f76b8c4ef496ec79bc80204d16.r2.dev/screenshots/2026/09/2026-09-27-175640-screenshot_27-sep_17-54-29_23785.png)

1. O modelo recebe o conjunto de questões ou prompts junto com contexto do sistema, programa ou conversa.
2. Avalia cada pergunta em paralelo
3. Devolve a resposta com probabilidades e tipo de questão
4. Um código usa essa resposta para tomar uma decisão.

## TypeSafe Primitives
São os tipos de respostas possíveis. Há apenas 3:
1. Choice: Uma opção de uma lista predefinida
2. Score: O valor da questão numa escala predefinida (exemplo: 0 a 10)
3. Noul: usado para responder resposta binárias de sim ou não.

## Exemplo de instrução estruturada

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

Aqui temos um exemplo de instrução, `"state"` é um contexto que é dado, `"questions"` são a lista de decisões que o modelo toma. Bem simples, só tem uma pergunta:
*Qual time deveria lidar com isso?*

E o modelo deve escolher um dos critérios
`"return"`, `"shipping"` ou `"billing"`.

Uma resposta seria como:
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

# Confiança vs Probabilidade
O Jev usa 2 conceitos importantes:
- Probabilidade: descreve a chance do modelo escolher alguma das resposta
- Confiança: descreve o quão confiante o modelo tá da resposta que deu. É uma derivação das probabilidades. Quanto uma uma probabilidade se concentra numa única escolha, mais "confiante" ele está da escolha que fez.
# Modelos Abertos

Atualmente o Jev é proprietário e disponível apenas via API. Mas existem alguns modelos open-sources que você consegue rodar localmente.  O mais famoso é o [Laya](https://laya.convaiinnovations.com/), em geral ele é mais rápido que o Jev, simplesmente porque os testes acontecem localmente e como não sofre com latência, obviamente o Laya é mais rápido

Porém tem um detalhe que passa despercebido, para a maioria dos casos é necessários fazer um "fine tunning" no Laya para ele se adequar ao seu problema