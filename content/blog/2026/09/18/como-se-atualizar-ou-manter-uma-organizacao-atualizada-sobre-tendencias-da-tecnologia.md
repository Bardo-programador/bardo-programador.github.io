---
title: "Como se atualizar ou manter uma organização atualizada sobre tendências da tecnologia?"
date: 2026-09-18T17:02:51-03:00
slug: "como-se-atualizar-ou-manter-uma-organizacao-atualizada-sobre-tendencias-da-tecnologia"
description: "Aprenda sobre radar de têndencias da Thought Works."
tags: ["tech", "dia-a-dia"]
authors:
  - name: "Bardo Programador"
    link: "https://github.com/Bardo-programador"
---
O mercado de tecnologia tem uma tendência de evoluir muito rápido e pode ser difícil se atualizar sobre ele. Uma forma que eu encontrei de me atualizar sobre ele foi me basear no radar da Thought Works.

# O que é a Thought Works?
É uma empresa de consultoria e desenvolvimento de software que oferece serviços de consultoria, treinamento e mentoria em desenvolvimento de software.

## O radar da Thought Works
A Thought Works semestralmente faz uma reunião com engenheiros e desenvolvedores sêniores e lançam um "radar" com coisas de interesse da tecnologia. O radar trata de ferramentas, técnicas, plataformas, linguagens e frameworks que valem pena dar uma olhada, e também o que não vale tanto.\
O radar deles está disponível (tanto em português quanto em inglês) em [https://www.thoughtworks.com/radar](https://www.thoughtworks.com/radar).

![screenshot_18 sep_17 13 53_18418](https://pub-9e61c7f76b8c4ef496ec79bc80204d16.r2.dev/screenshots/2026/09/2026-09-18-171426-screenshot_18-sep_17-13-53_18418.png)
O radar deles se dividem em 4 quadrantes neste formato com as categorias:
- Adote: o que vale a pena adotar na organização e já foi amplamente validado
- Experimente: o que vale a pena experimentar, mas não tão testado 
- Avalie: algo que vale a pena dar ao menos uma olhada, para ver se pode ser útil
- Cautela: algo não necessariamente ruim, mas que pode ser muito novo e que ainda está em fase de desenvolvimento.


O radar de 2026 é o seguinte:
![screenshot_18 sep_17 19 17_1506](https://pub-9e61c7f76b8c4ef496ec79bc80204d16.r2.dev/screenshots/2026/09/2026-09-18-171935-screenshot_18-sep_17-19-17_1506.png)

E mais abaixo uma tabela com nome dos elementos
![screenshot_18 sep_17 20 35_23950](https://pub-9e61c7f76b8c4ef496ec79bc80204d16.r2.dev/screenshots/2026/09/2026-09-18-172048-screenshot_18-sep_17-20-35_23950.png)

E se você prestar atenção no número 70, você verá ele: o [mise]({{< relref "como-instalar-qualquer-ferramenta-com-o-mise" >}}), então dá uma olhada se ainda não viu.


# Como criar o próprio radar?
Eles também disponibilizam o [código-fonte](https://github.com/thoughtworks/build-your-own-radar) para você criar o seu próprio radar. A maneira mais fácil é criar uma planilha no Google Sheets (ou arquivo CSV/JSON) seguindo este formato de colunas:

| name          | ring    | quadrant               | isNew | description                                             |
| ------------- | ------- | ---------------------- | ----- | ------------------------------------------------------- |
| Composer      | adopt   | tools                  | TRUE  | Although the idea of dependency management ...          |
| Canary builds | trial   | techniques             | FALSE | Many projects have external code dependencies ...       |
| Apache Kylin  | assess  | platforms              | TRUE  | Apache Kylin is an open source analytics solution ...   |
| JSF           | Caution | languages & frameworks | FALSE | We continue to see teams run into trouble using JSF ... |

Exemplo em formato CSV:

```csv
name,ring,quadrant,isNew,description
Composer,adopt,tools,TRUE,"Although the idea of dependency management..."
Canary builds,trial,techniques,FALSE,"Many projects have external code dependencies..."
Apache Kylin,assess,platforms,TRUE,"Apache Kylin is an open source analytics solution..."
JSF,hold,languages & frameworks,FALSE,"We continue to see teams run into trouble using JSF..."
```

Exemplo no formato JSON:
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
Depois use a página [web](https://radar.thoughtworks.com/) deles e cole o link do arquivo no campo de preenchimento da página e clique em *Build my radar* (Construir meu radar). E pronto, você pode visualizar seu próprio radar e no botão abaixo clicar em *Imprima esse radar*.

## Versão Self-Host 
Se quiser hospedar na própria infraestrutura, pode usar a versão Docker.

```bash
mkdir -p ./radar-files
docker run --rm -d --name tech-radar -p 8080:80 -e SERVER_NAMES="localhost 127.0.0.1" -v $(pwd)/radar-files:/opt/build-your-own-radar/files wwwthoughtworks/build-your-own-radar
```

Isso vai criar uma pasta `radar-files` no diretório atual e rodar o container docker. Depois coloque o arquivo da sua planilha em `radar-files` (vou chamar de radar.csv). Abra o navegador no url [localhost:8080](localhost:8080) e coloque o link no seguinte formato:
- localhost:8080/files/radar.csv 
Troque o radar.csv pelo nome do seu arquivo. E pronto!

![screenshot_18 sep_18 34 30_7726](https://pub-9e61c7f76b8c4ef496ec79bc80204d16.r2.dev/screenshots/2026/09/2026-09-18-183457-screenshot_18-sep_18-34-30_7726.png)

Se quiser tem a versão em Docker Compose:

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
