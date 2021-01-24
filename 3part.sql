create type paymentmethod_types as enum ('QIWI', 'Yandex.Money', 'Credit card', 'WebMoney');
create type transaction_types as enum('Sale', 'Purchase');
create type attributes as enum('Force', 'Intelligence', 'Agility');
create type rarities as enum('Common', 'Uncommon', 'Rare', 'Mythical', 'Legendary', 'Immortal', 'Arcana', 'Ancient');

create table trading_platform (
    platform_id serial primary key,
    platform_name varchar not null,
    things_border integer not null
);

create table avatar (
    avatar_id serial primary key,
    link_photo varchar not null,   
    width integer,
    height integer
);

create table rating (
    rating_id serial primary key,
    rating_num integer not null check(rating_num > 0 and rating_num < 10000) default 1,
    transactions_num integer not null,
    time_decrease_const timestamp not null,
    offense_num integer not null
);

create table paymentmethod (
    payment_id serial primary key,
    customer_id references customer (customer_id) on update cascade on delete cascade,
    credentials varchar not null,
    paymentmethod_name varchar(32) not null,
    paymentmethod_type paymentmethod_types not null,
    customer_balance integer default 0
                    CHECK (customer_balance >= 0)
);

create table customer (
    customer_id serial primary key,
    avatar_id integer references avatar (avatar_id) on update cascade on delete cascade,
    rating_id integer references rating (rating_id) on update cascade on delete cascade,
    platform_id integer references trading_platform (platform_id) on update cascade on delete cascade,
    customer_name varchar(32) not null,
    customer_last_name varchar(32) not null,
    customer_nick_name varchar(32) not null,
    age integer not null check (age > 0 and age < 120),
    become_offline_time timestamp
);

create index hash_customer_id on customer using hash (customer_id);

create table thing (
    thing_id serial primary key,
    customer_id integer references customer (customer_id) on update cascade on delete cascade,
    platform_id integer references trading_platform (platform_id) on update cascade on delete cascade,
    is_selling boolean default true,   
    rarity rarities not null,
    thing_name varchar(32) not null,
    price integer not null
);
create index hash_thing_id on thing using hash (thing_id);  
-- основные операции будут транзакции, где нужно будет находить пользователей и вещи по id, поэтому имеет смысл сделать hash  индексы для этих полей, тк они оптимальны 
--для операций равенства

create table bonus (
    bonus_id serial primary key,
    thing_id integer references thing (thing_id) on update cascade on delete cascade,
    rating_scale integer not null check(rating_scale > 0 and rating_scale < 10000)
);


create table character (
    character_id serial primary key,
    thing_id integer references thing (thing_id) on update cascade on delete cascade,
    platform_id integer references trading_platform (platform_id) on update cascade on delete cascade,
    character_name varchar(32) not null,
    attribute attributes not null
);
create index hash_character_id on character using hash (character_id);

create table message (
    message_id serial primary key,
    sender_id integer references customer (customer_id) on update cascade on delete cascade,
    recipient_id integer references customer (customer_id) on update cascade on delete cascade,
    content varchar not null,
    send_time timestamp not null
);

create table transaction (
    transaction_id serial primary key,
    first_customer_id integer references customer (customer_id) on update cascade on delete cascade,
    sec_customer_id integer references customer (customer_id) on update cascade on delete cascade, 
    first_thing_id integer references thing (thing_id) on update cascade on delete cascade,
    sec_thing_id integer references thing (thing_id) on update cascade on delete cascade,
    platform_id integer references trading_platform (platform_id) on update cascade on delete cascade,
    description varchar,
    transaction_type transaction_types not null
);


-- аватары
insert into avatar(link_photo, width, height) values('https://www.flaticon.com/svg/static/icons/svg/2922/2922506.svg', 256, 256);
insert into avatar(link_photo, width, height) values('https://www.flaticon.com/svg/static/icons/svg/2922/2922244.svg', 256, 256);
insert into avatar(link_photo, width, height) values('https://www.flaticon.com/svg/static/icons/svg/2922/2232468.svg', 256, 256);
insert into avatar(link_photo, width, height) values('https://www.flaticon.com/svg/static/icons/svg/2922/2922368.svg', 256, 256);
insert into avatar(link_photo, width, height) values('https://www.flaticon.com/svg/static/icons/svg/2922/2422468.svg', 256, 256);
insert into avatar(link_photo, width, height) values('https://www.flaticon.com/svg/static/icons/svg/2922/2934468.svg', 256, 256);
insert into avatar(link_photo, width, height) values('https://www.flaticon.com/svg/static/icons/svg/2922/2922468.svg', 256, 256);
insert into avatar(link_photo, width, height) values('https://www.flaticon.com/svg/static/icons/svg/2922/2452468.svg', 256, 256);

-- измени ссылки на фотки плз, у меня короткие не делаются почему-то
-- рейтинг
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(1, 9999,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(2, 9800,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(3, 9721,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(4, 9654,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(5, 9638,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(6, 9502,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(7, 9489,'Wed 17 Dec 07:37:16 1997 PST ' ,0);
--способ оплаты
insert into paymentmethod(credentials, paymentmethod_name, paymentmethod_type) values('12923094340', 'Sberbank', 'Credit card');
insert into paymentmethod(credentials, paymentmethod_name, paymentmethod_type) values('12924094340', 'Citybank', 'Credit card');
insert into paymentmethod(credentials, paymentmethod_name, paymentmethod_type) values('12456094340', 'QIWI',     'Credit card');
insert into paymentmethod(credentials, paymentmethod_name, paymentmethod_type) values('12325943440', 'Yandex.Money', 'Yandex.Money');
insert into paymentmethod(credentials, paymentmethod_name, paymentmethod_type) values('12765345640', 'Yandex.Money', 'Yandex.Money');
insert into paymentmethod(credentials, paymentmethod_name, paymentmethod_type) values('12945094340', 'Bitcoins', 'WebMoney');
--торговая площадка
insert into trading_platform(platform_name, things_border) values('Dota2', 60000);
insert into trading_platform(platform_name, things_border) values('CSGO', 62000);
insert into trading_platform(platform_name, things_border) values('CiberPunk', 63000);
insert into trading_platform(platform_name, things_border) values('PUBG', 32000);
--клиент
insert into customer(avatar_id , rating_id, platform_id, customer_name, customer_last_name, customer_nick_name, age, become_offline_time) values(1, 1, 1,'Alexey', 'Pismak' 'Lexa2010', 11,'2020-12-19 10:23:54' );
insert into customer(avatar_id , rating_id, platform_id, customer_name, customer_last_name, customer_nick_name, age, become_offline_time) values(2, 2, 1,'Dmitriy','Afanasief', 'DimasMashina', 13,'2020-12-19 11:23:54' );
insert into customer(avatar_id , rating_id, platform_id, customer_name, customer_last_name, customer_nick_name, age, become_offline_time) values(3, 4, 1, 'Evgeniy', 'Copa', 'sixteen', 21,'2020-11-28 22:23:54' );
insert into customer(avatar_id , rating_id, platform_id, customer_name, customer_last_name, customer_nick_name, age, become_offline_time) values(4, 3, 1, 'Andrey', 'Shalya','vedroid', 15,'2020-12-18 19:23:54' );
insert into customer(avatar_id , rating_id, platform_id, customer_name, customer_last_name, customer_nick_name, age, become_offline_time) values(5, 5, 1,  'Vlad', 'Pomelnikov', 'VladKrutisna2', 14,'2020-12-19 12:23:54' );
--шмотки
insert into thing(customer_id, platform_id , rarity, thing_name, price) values(1,1, 'Immortal', 'Rippers Reel of the Crimson Witness', 7832);
insert into thing(customer_id, platform_id , rarity, thing_name, price) values(1,1, 'Immortal', 'Rippers ', 7832);
insert into thing(customer_id, platform_id , rarity, thing_name, price) values(2,1, 'Mythical', 'Hunger ofthe Howling Wilds', 1011);
insert into thing(customer_id, platform_id , rarity, thing_name, price) values(3,1, 'Immortal', 'Dragonclaw Hook', 63200);
insert into thing(customer_id, platform_id , rarity, thing_name, price) values(4,1, 'Immortal', 'Bracers of Aeons of the Crimson Witness', 33400);
insert into thing(customer_id, platform_id , rarity, thing_name, price) values(5,1, 'Immortal', 'Sylvan Vedette', 2400);
insert into thing(customer_id, platform_id , rarity, thing_name, price) values(4,1, 'Immortal', 'Rippers Reel of the Crimson Witness', 7833);
insert into thing(customer_id, platform_id , rarity, thing_name, price) values(5,1, 'Immortal', 'Armor of the Demon Trickster', 5600);  
insert into thing(customer_id, platform_id , rarity, thing_name, price) values(2,1, 'Immortal', 'Mask of the Demon Trickster', 2000); 
insert into thing(customer_id, platform_id , rarity, thing_name, price) values(2,1, 'Immortal', 'Roshan Hunter', 132900); 
insert into thing(customer_id, platform_id , rarity, thing_name, price) values(3,1, 'Immortal', 'Mask of the Demon Trickster', 2000); 

insert into thing(customer_id, platform_id , rarity, thing_name, price) values(1,1, 'Legendary', 'Roshan Hunter', 132900); 
--бонусы
insert into bonus(thing_id, rating_scale) values(1, 9500); 
-- персонажи 
insert into character(thing_id, platform_id, character_name, attribute) values(1, 1, 'Pudge', 'Force'); 
insert into character(thing_id, platform_id, character_name, attribute) values(2, 1, 'Riki', 'Agility');
insert into character(thing_id, platform_id, character_name, attribute) values(3, 1, 'Pudge', 'Force');
insert into character(thing_id, platform_id, character_name, attribute) values(4, 1, 'Faceless Viod', 'Agility');
insert into character(thing_id, platform_id, character_name, attribute) values(5, 1, 'Windranger', 'Intelligence');
insert into character(thing_id, platform_id, character_name, attribute) values(6, 1, 'Pudge', 'Force');
insert into character(thing_id, platform_id, character_name, attribute) values(7, 1, 'Monkey King', 'Agility');
insert into character(thing_id, platform_id, character_name, attribute) values(8, 1, 'Monkey King', 'Agility');
insert into character(thing_id, platform_id, character_name, attribute) values(9, 1, 'Ursa', 'Agility');
insert into character(thing_id, platform_id, character_name, attribute) values(10, 1, 'Monkey King', 'Agility');



insert into character(thing_id, platform_id, character_name, attribute) values(19, 1, 'Pudge', 'Force'); 
insert into character(thing_id, platform_id, character_name, attribute) values(20, 1, 'Riki', 'Agility');
insert into character(thing_id, platform_id, character_name, attribute) values(21, 1, 'Pudge', 'Force');
--способы оплаты клиента и баланс
insert into paymentmethod(customer_id, credentials, paymentmethod_name, paymentmethod_type, customer_balance) values(1,'21124412421','Sberbank','Credit card', 28345);
insert into paymentmethod(customer_id, credentials, paymentmethod_name, paymentmethod_type, customer_balance) values(2,'21122312421','Yandex.Money','Yandex.Money', 31345);
insert into paymentmethod(customer_id, credentials, paymentmethod_name, paymentmethod_type, customer_balance) values(3,'21176542421','Sberbank','Credit card', 8345);
insert into paymentmethod(customer_id, credentials, paymentmethod_name, paymentmethod_type, customer_balance) values(4,'21124413421','Citybank','Credit card', 18345);
insert into paymentmethod(customer_id, credentials, paymentmethod_name, paymentmethod_type, customer_balance) values(5,'21127653421','Qiwi','QIWI', 4345);

-- сообщения 
insert into message(sender_id, recipient_id, content, send_time) values(1,2, 'Привет, как сам?','2020-12-19 10:23:54');
insert into message(sender_id, recipient_id, content, send_time) values(2,1, 'Ку, норм. А ты ?','2020-12-19 10:24:20');
insert into message(sender_id, recipient_id, content, send_time) values(1,2, 'Не хочешь снизить цену на своего крысюка? У тебя уже месяц никто не покупает','2020-12-19 10:25:54');
insert into message(sender_id, recipient_id, content, send_time) values(2,1, 'Не, у меня не горит, могу подождать','2020-12-19 10:26:54');
--транзакции
insert into transaction(first_customer_id , sec_customer_id , first_thing_id, sec_thing_id, platform_id, transaction_type  ) values(1, 2, 1, null, 1, 'Sale');

--Тригер который проверяет если превышено максимальное количество вещей то добавления не происходит    
CREATE OR REPLACE FUNCTION thing_border_prevent_proc()
RETURNS trigger AS $$
    declare 
        thingsNum INT;
        thingsBorder INT;
    begin
        select count(*) into thingsNum from thing;
        select things_border into thingsBorder from trading_platform where platform_id = new.platform_id;
        if thingsNum <= thingsBorder then
          return new;
        else 
          return null;
        end if;
    end;
 $$ LANGUAGE plpgsql;

 create trigger thing_border_prevent_trigger before insert on thing FOR EACH ROW EXECUTE PROCEDURE thing_border_prevent_proc();


--Тригер подсчитывающий рейтинг на основе его атрибутов

CREATE OR REPLACE FUNCTION rating_count_proc()
RETURNS trigger AS $$
    begin
       new.rating_num = new.rating_num + (new.transactions_num * 10 - new.offense_num * 3);
    end;
 $$ LANGUAGE plpgsql;

create trigger rating_count_trigger before insert on rating FOR EACH ROW EXECUTE PROCEDURE rating_count_proc();

--Тригер устанавливающий время отправки сообщения

CREATE OR REPLACE FUNCTION message_time_proc()
RETURNS trigger AS $$
    begin
       new.send_time = CURRENT_TIMESTAMP;
    end;
 $$ LANGUAGE plpgsql;

create trigger message_time_trigger before insert on rating FOR EACH ROW EXECUTE PROCEDURE message_time_proc();


--Тригер инкрементирующий атрибут транзакций рейтинга

CREATE OR REPLACE FUNCTION transaction_proc()
RETURNS trigger AS $$
    declare 
        firstUserTransact INT;
        firstUserRatingID INT;
        secUserTransact INT;
        secUserRatingID INT; 

    begin
        select rating_id into firstUserRatingID  from customer where customer_id = new.first_customer_id;
        select rating_id into secUserRatingID from customer where customer_id = new.sec_customer_id;
        select transactions_num into firstUserTransact from rating
                                        where rating_id = firstUserRatingID;
        
        select transactions_num into secUserTransact from rating
                                        where rating_id = secUserRatingID;
        update rating
            set transactions_num = (firstUserTransact + 1)
        where rating_id = firstUserRatingID;

        update rating
            set transactions_num = (secUserTransact + 1)
        where rating_id = secUserRatingID;
    end;
 $$ LANGUAGE plpgsql;

 create trigger transaction_trigger before insert on transaction FOR EACH ROW EXECUTE PROCEDURE transaction_proc();


--Процедура осуществляющяя выход пользователя из онлайна


CREATE OR REPLACE FUNCTION  user_exit (customer_id integer) returns void as $$
    begin
      update customer
         set become_offline_time= CURRENT_TIMESTAMP
       where customer_id = customer_id;
    end;
    $$ LANGUAGE plpgsql;

create index "customer_id_index" on customer using hash("customer_id");

create view things_view 
as  select t.thing_id, t.thing_name, t.rarity, cus.customer_nick_name, cha.character_name, t.price
from thing t join customer cus using(customer_id) join character cha using(thing_id) where t.is_selling = true;




CREATE OR REPLACE FUNCTION  thing_info (thing_id_find integer) returns table(thing_id integer, customer_id integer, trading_platform_id integer, is_selling boolean, rarity rarities, thing_name varchar(32), price integer) as $$
begin
    return query select * from thing t where thing_id_find = t.thing_id;
end;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION  message_info (originator integer) returns table(sender_id integer,recipient_id integer, content varchar) as $$
begin
    return query select m.sender_id, m.recipient_id, m.content from message m where (originator = m.sender_id) or (originator=m.recipient_id) ;
end;
$$ LANGUAGE plpgsql;  



CREATE OR REPLACE FUNCTION  message_info_sendler_recipient (originator integer, addressee integer) returns table(sender_id integer,recipient_id integer, content varchar) as $$
begin
    return query select m.sender_id, m.recipient_id, m.content from message m where (originator = m.sender_id) or (addressee = m.recipient_id) ;
end;
$$ LANGUAGE plpgsql;  




CREATE OR REPLACE FUNCTION  user_info (originator integer) returns table(recipient_id integer, customer_name varchar) as $$
begin
    return query select DISTINCT m.recipient_id, c.customer_name from message m join customer c  on (m.recipient_id = c.customer_id) where (m.sender_id = originator) or (m.recipient_id = originator);
end;
$$ LANGUAGE plpgsql;  
