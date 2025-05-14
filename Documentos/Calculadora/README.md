# Calculadora-CompassUOL

# Calculadora Python - Projeto de Desenvolvimento Guiado por Testes (TDD)

## Descrição

Este projeto implementa uma **calculadora em Python**, utilizando o conceito de **Desenvolvimento Guiado por Testes (TDD)** para garantir a robustez e a qualidade do código. A aplicação oferece uma **interface simples** para o usuário realizar as 4 operações matemáticas básicas, além de incluir funcionalidades adicionais, como **potência** e **fatorial**.

## Funcionalidades

- **Operações Básicas**: Adição, subtração, multiplicação e divisão.
- **Operações Avançadas**: Potência e fatorial.
- **Tratamento de Erros**: A aplicação inclui validações para garantir que erros como **divisão por zero** e **fatorial de números negativos** sejam tratados corretamente.
- **Interface de Entrada**: Um sistema interativo solicita ao usuário os números e a operação desejada, realizando o cálculo e retornando o resultado.

## Estrutura do Projeto

A estrutura do projeto segue uma organização simples e eficaz para promover a modularidade e a reutilização do código:


```
Calculadora/
├── calculadora/
│   ├── __init__.py          # Pacote do diretório
│   └── core.py              # Classe Calculadora com operações matemáticas
│   └── main.py              # Interface da aplicação
├── tests/
│   ├── __init__.py          # Pacote do diretório
│   └── test_core.py         # Testes automatizados utilizando pytest     
```


## Como Executar o Projeto

  1. **Clone o repositório**:
  ```
  git clone https://github.com/Casx1/Documentos-CompassUOL.git
  ```
  2. **Após o clone, entre no diretório do projeto:**
  ```
  cd repo
  ```
  
  3. **Instale as dependências (caso necessário):**
  ```
  pip install -r dependencies.txt
  ```
  4. **Execute o código principal (main.py):**
  ```
  python main.py
  ```

O programa solicitará ao usuário que insira dois números e a operação matemática desejada, e então calculará e exibirá o resultado.

### Como Rodar os Testes
O projeto inclui testes unitários para garantir que as operações matemáticas estejam funcionando corretamente. Para rodar os testes, siga os passos abaixo:

1. **Instale o pytest:**
Se você ainda não tiver o pytest instalado, execute:
```
pip install pytest
```

2. **Execute os testes:**
Para rodar os testes unitários, execute o seguinte comando:
```
pytest testing.py
```

O pytest irá rodar todos os testes definidos no arquivo testing.py, verificando se todas as operações funcionam corretamente e se os erros são tratados adequadamente.

## Tecnologias Utilizadas
**Python 3.x:** Linguagem de programação utilizada para implementar a calculadora.

**pytest:** Framework de testes para garantir a confiabilidade do código.

**Desenvolvimento Guiado por Testes (TDD):** Estratégia de desenvolvimento adotada para implementar os métodos da calculadora.

## Contribuição
Contribuições são bem-vindas! Se você encontrar um bug ou tiver uma sugestão de melhoria, sinta-se à vontade para abrir uma issue ou enviar um pull request.

