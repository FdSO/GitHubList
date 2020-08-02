
# GitHubList

O desafio consiste em um aplicativo que consume dados através da API REST do GitHub.

### Funcionalidades

 - [x] Lista de Repositórios com Paginação por demanda
 - [x] Detalhes do Repositório com Listagem de PullRequests
 - [x] Salva e Remove Repositórios do Aplicativo
 
Compatível em iOS10+ e possui Layout Adaptado para Iphone e Ipad em orientação de tela Portrait e Landscape.

## Conteúdo Técnico utilizado no Projeto

 - Swift 5
 - ViewCode
 - Model-View-ViewModel
 - Coordinator
 - CoreData
 - Swift Package Manager
 - Unit Test
 - UI Test
 - AutoLayout

Aplicativo finalizado e projetado com uso de TableViewController em todas as funcionalidades. Também possui cancelamento de requisições ao sair do contexto de tela atual e foi desenhado utilizando componentes de UI nativa como descrito em [Human Guideline Interface](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/)

Projeto com estilo de escrita baseado no [Swift Style Guide by google](https://google.github.io/swift/) com documentação (comentários) do código em Português e histórico de Commits em Inglês com base de formato em [Convencional Commits](https://www.conventionalcommits.org/en/v1.0.0/)

### Bibliotecas utilizadas:

Bibliotecas configuradas através do gerenciador de dependências Swift Package Manager.

 1. ***Alamofire***: para consumo de API Rest e parse do JSON de resposta.
 2. ***AlamofireImage***: para download de imagens, corte e cache.
 3. ***PureLayout***: para auxiliar na construção de componentes e layout no ViewCode.
