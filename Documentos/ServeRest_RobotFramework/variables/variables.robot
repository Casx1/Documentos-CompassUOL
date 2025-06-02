*** Variables ***
# URL Base da API
${base_url}                     https://compassuol.serverest.dev

# Dados do Usuário Válido
${nome_do_usuario}              Challenge Compass User
${email_do_usuario}             challenge.compass@automation.com
${senha_do_usuario}             automation123

# Dados do Usuário Admin
${nome_admin}                   Admin Challenge User
${email_admin}                  admin.challenge@automation.com
${senha_admin}                  admin123

# Dados do Usuário Não-Admin
${nome_nao_admin}               Regular Challenge User
${email_nao_admin}              regular.challenge@automation.com
${senha_nao_admin}              regular123

# E-mails Inválidos para Testes
${email_gmail}                  teste@gmail.com
${email_hotmail}                teste@hotmail.com
${email_malformado}             email-sem-arroba.com
${email_inexistente}            inexistente@automation.com

# Senhas para Testes de Limite
${senha_limite_min}             12345
${senha_limite_max}             1234567890

# Dados de Produto Válido
${nome_produto}                 Produto Challenge Compass
${preco_produto}                100
${descricao_produto}            Produto para testes automatizados do Challenge Compass
${quantidade_produto}           50

# Dados de Produto Duplicado
${nome_produto_duplicado}       Produto Duplicado Test

# Dados Inválidos para Produtos
${preco_invalido}               0
${quantidade_invalida}          -1

# Variáveis de Controle
${USUARIO_ID}                   ${EMPTY}
${PRODUTO_ID}                   ${EMPTY}
${TOKEN_ADMIN}                  ${EMPTY}
${TOKEN_REGULAR}                ${EMPTY}
${ID_INEXISTENTE}               999999999999999999999999