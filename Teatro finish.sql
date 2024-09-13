Create database Teatro;
use teatro;

create table pecas_teatro(
id_pecateatro int auto_increment,
nome_peca varchar(60),
descricao varchar(80),
duracao int,
data_estreia date,
preco decimal(10,2),
constraint id_pecapk primary key (id_pecateatro));


insert into pecas_teatro(nome_peca,descricao,duracao,data_estreia,preco)
Values('O livro de dom pedro', 'negão batendo em todo mundo', 90, '2021-05-15',69.00);

select * from pecas_teatro;


DELIMITER //

CREATE FUNCTION calcular_media_duracao(p_id_pecateatro INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE media_duracao FLOAT;

    -- Calcula a média da duração das peças com o id_pecateatro fornecido
    SELECT AVG(duracao) INTO media_duracao
    FROM pecas_teatro
    WHERE id_pecateatro = p_id_pecateatro;

    -- Retorna a média calculada
    RETURN media_duracao;
END //

DELIMITER ;


drop function calcular_media_duracao;

SELECT calcular_media_duracao(2) AS media_duracao;






ALTER TABLE pecas_teatro
ADD COLUMN data_apresentacao DATE;






DELIMITER //

CREATE FUNCTION verificar_disponibilidade(p_data_hora DATETIME)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE existe_agendamento INT;

    -- Verifica se há alguma peça agendada para a data e hora fornecidas
    SELECT CASE
        WHEN COUNT(*) > 0 THEN 1
        ELSE 0
    END INTO existe_agendamento
    FROM pecas_teatro
    WHERE data_hora_apresentacao = p_data_hora;

    -- Retorna 1 se houver um agendamento para a data e hora fornecidas, 0 caso contrário
    RETURN existe_agendamento;
END //

DELIMITER ;



drop function verificar_disponibilidade;
SELECT verificar_disponibilidade('2024-09-15') AS disponibilidade;






DELIMITER //

CREATE PROCEDURE agendar_peca(
    IN p_nome_peca VARCHAR(60),
    IN p_descricao VARCHAR(80),
    IN p_duracao INT,
    IN p_data_hora DATETIME,
    IN p_preco DECIMAL(10,2)
)
BEGIN
    DECLARE disponibilidade INT;
    DECLARE media_duracao DECIMAL(10,2);
    DECLARE id_novo_peca INT;

    -- Verifica a disponibilidade para a data e hora fornecidas
    SET disponibilidade = (SELECT verificar_disponibilidade(p_data_hora));

    -- Se a data e hora estiverem disponíveis, insere a nova peça
    IF disponibilidade = 0 THEN
        -- Insere a nova peça de teatro
        INSERT INTO pecas_teatro (nome_peca, descricao, duracao, data_hora_apresentacao, preco)
        VALUES (p_nome_peca, p_descricao, p_duracao, p_data_hora, p_preco);
        
        -- Obtém o id da nova peça inserida
        SET id_novo_peca = LAST_INSERT_ID();
        
        -- Calcula a média de duração das peças
        SET media_duracao = (SELECT calcular_media_duracao());
        
        -- Imprime informações sobre a peça agendada e a média de duração
        SELECT 
            'Peça agendada com sucesso!' AS Mensagem,
            id_novo_peca AS ID_Peca,
            p_nome_peca AS Nome_Peca,
            p_descricao AS Descricao,
            p_duracao AS Duracao,
            p_data_hora AS Data_Hora,
            p_preco AS Preco,
            media_duracao AS Media_Duracao;
    ELSE
        -- Se a data e hora não estiverem disponíveis, imprime uma mensagem de erro
        SELECT 'A data e hora fornecidas já estão ocupadas. Por favor, escolha outro horário.' AS Mensagem;
    END IF;
END //

DELIMITER ;

CALL agendar_peca(
    'Nome da Peça',
    'Descrição da Peça',
    120, -- Duração em minutos
    '2024-09-15 20:00:00', -- Data e Hora
    50.00 -- Preço
);


