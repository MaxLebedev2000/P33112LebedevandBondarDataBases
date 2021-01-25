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
    rating_num integer not null check(rating_num > 0) default 1,
    transactions_num integer not null,
    time_decrease_const integer not null,
    offense_num integer not null
);

--Тригер подсчитывающий рейтинг на основе его атрибутов

CREATE OR REPLACE FUNCTION rating_count_proc()
RETURNS trigger AS $$
    begin
       new.rating_num = new.rating_num + (new.transactions_num * 10 - new.offense_num * 3);
       return new;
    end;
 $$ LANGUAGE plpgsql;

create trigger rating_count_trigger before insert or update on rating FOR EACH ROW EXECUTE PROCEDURE rating_count_proc();

create table customer (
    customer_id serial primary key,
    avatar_id integer references avatar (avatar_id) on update cascade on delete cascade,
    rating_id integer references rating (rating_id) on update cascade on delete cascade,
    platform_id integer references trading_platform (platform_id) on update cascade on delete cascade,
    customer_name varchar(32) not null,
    customer_last_name varchar(32) not null,
    customer_nick_name varchar(32) not null unique,
    age integer not null check (age > 0 and age < 120),
    become_offline_time timestamp
);

--create index hash_customer_id on customer using hash (customer_id);
--create index hash_customer_nick_name on customer using hash (customer_nick_name);

create table paymentmethod (
    payment_id serial primary key,
    customer_nick_name varchar references customer (customer_nick_name) on update cascade on delete cascade,
    credentials varchar not null,
    paymentmethod_name varchar(32) not null,
    paymentmethod_type paymentmethod_types not null,
    customer_balance integer default 0
                    CHECK (customer_balance >= 0)
);

create table thing (
    thing_id serial primary key,
    customer_nick_name varchar references customer (customer_nick_name) on update cascade on delete cascade,
    platform_id integer references trading_platform (platform_id) on update cascade on delete cascade,
    is_selling boolean default true,   
    rarity rarities not null,
    thing_name varchar(32) not null,
    price integer not null
);
--create index hash_thing_id on thing using hash (thing_id);  
-- основные операции будут транзакции, где нужно будет находить пользователей и вещи по id, поэтому имеет смысл сделать hash  индексы для этих полей, тк они оптимальны 
--для операций равенства

create table bonus (
    bonus_id serial primary key,
    thing_id integer references thing (thing_id) on update cascade on delete cascade,
    rating_scale integer not null check(rating_scale > 0)
);


create table character (
    character_id serial primary key,
    thing_id integer references thing (thing_id) on update cascade on delete cascade,
    platform_id integer references trading_platform (platform_id) on update cascade on delete cascade,
    character_name varchar(32) not null,
    attribute attributes not null
);
--create index hash_character_id on character using hash (character_id);

create table message (
    message_id serial primary key,
    sender_nick varchar references customer (customer_nick_name) on update cascade on delete cascade,
    recipient_nick varchar references customer (customer_nick_name) on update cascade on delete cascade,
    content varchar not null,
    send_time timestamp 
);
--create index hash_sender_nick on message using hash (sender_nick);
--create index hash_recipient_nick on message using hash (recipient_nick);
--create index hash_message_id on message using hash (message_id);

create table transaction (
    transaction_id serial primary key,
    first_customer_nick varchar references customer (customer_nick_name) on update cascade on delete cascade,
    sec_customer_nick varchar references customer (customer_nick_name) on update cascade on delete cascade, 
    first_thing_id integer references thing (thing_id) on update cascade on delete cascade,
    sec_thing_id integer references thing (thing_id) on update cascade on delete cascade,
    platform_id integer references trading_platform (platform_id) on update cascade on delete cascade,
    description varchar,
    transaction_type transaction_types not null
);
--create index hash_transaction_id on transaction using hash (transaction_id);
--create index hash_first_customer_nick on transaction using hash (first_customer_nick);
--create index hash_sec_customer_nick on transaction using hash (sec_customer_nick);
--create index hash_first_thing_id on transaction using hash (first_thing_id);


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
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(1, 9999, 7,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(2, 9800, 7,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(3, 9721, 7,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(4, 9654, 7,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(5, 9638, 7,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(6, 9502, 7,0);
insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(7, 9489, 7,0);
--торговая площадка
insert into trading_platform(platform_name, things_border) values('Dota2', 60000);
insert into trading_platform(platform_name, things_border) values('CSGO', 62000);
insert into trading_platform(platform_name, things_border) values('CiberPunk', 63000);
insert into trading_platform(platform_name, things_border) values('PUBG', 32000);
--клиент
insert into customer(avatar_id , rating_id, platform_id, customer_name, customer_last_name, customer_nick_name, age, become_offline_time) values(1, 1, 1,'Alexey', 'Pismak', 'Lexa2010', 11,'2020-12-19 10:23:54' );
insert into customer(avatar_id , rating_id, platform_id, customer_name, customer_last_name, customer_nick_name, age, become_offline_time) values(2, 2, 1,'Dmitriy','Afanasief', 'DimasMashina', 13,'2020-12-19 11:23:54' );
insert into customer(avatar_id , rating_id, platform_id, customer_name, customer_last_name, customer_nick_name, age, become_offline_time) values(3, 4, 1, 'Evgeniy', 'Copa', 'sixteen', 21,'2020-11-28 22:23:54' );
insert into customer(avatar_id , rating_id, platform_id, customer_name, customer_last_name, customer_nick_name, age, become_offline_time) values(4, 3, 1, 'Andrey', 'Shalya','vedroid', 15,'2020-12-18 19:23:54' );
insert into customer(avatar_id , rating_id, platform_id, customer_name, customer_last_name, customer_nick_name, age, become_offline_time) values(5, 5, 1,  'Vlad', 'Pomelnikov', 'VladKrutisna2', 14,'2020-12-19 12:23:54' );
--шмотки
insert into thing(customer_nick_name, platform_id , rarity, thing_name, price) values(null,1, 'Immortal', 'Rippers Reel of ', 7832);
insert into thing(customer_nick_name, platform_id , rarity, thing_name, price) values(null,1, 'Immortal', 'Rippers ', 7832);
insert into thing(customer_nick_name, platform_id , rarity, thing_name, price) values(null,1, 'Mythical', 'Hunger ', 1011);
insert into thing(customer_nick_name, platform_id , rarity, thing_name, price) values(null,1, 'Immortal', 'Dragonclaw Hook', 63200);
insert into thing(customer_nick_name, platform_id , rarity, thing_name, price) values(null,1, 'Immortal', 'Bracers of Aeons of the ', 33400);
insert into thing(customer_nick_name, platform_id , rarity, thing_name, price) values(null,1, 'Immortal', 'Sylvan Vedette', 2400);
insert into thing(customer_nick_name, platform_id , rarity, thing_name, price) values(null,1, 'Immortal', 'Rippers Reel of the Crimson', 7833);
insert into thing(customer_nick_name, platform_id , rarity, thing_name, price) values(null,1, 'Immortal', 'Armor of the Demon Trickster', 5600);  
insert into thing(customer_nick_name, platform_id , rarity, thing_name, price) values(null,1, 'Immortal', 'Mask of the Demon Trickster', 2000); 
insert into thing(customer_nick_name, platform_id , rarity, thing_name, price) values(null,1, 'Immortal', 'Roshan Hunter', 132900); 
insert into thing(customer_nick_name, platform_id , rarity, thing_name, price) values(null,1, 'Immortal', 'Mask of the Demon Trickster', 2000); 
insert into thing(customer_nick_name, platform_id , is_selling, rarity, thing_name, price) values(null,1, true, 'Immortal', 'Mask of the Demon Trickster', 2000); 
insert into thing(customer_nick_name, platform_id , is_selling, rarity, thing_name, price) values(null,1, true, 'Immortal', 'Rippers', 7832);
insert into thing(customer_nick_name, platform_id , is_selling, rarity, thing_name, price) values(null,1, true, 'Immortal', 'Dragonclaw Hook', 63200);
insert into thing(customer_nick_name, platform_id , is_selling, rarity, thing_name, price) values(null,1, true, 'Immortal', 'Sylvan Vedetter', 2400);




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



insert into character(thing_id, platform_id, character_name, attribute) values(1, 1, 'Pudge', 'Force'); 
insert into character(thing_id, platform_id, character_name, attribute) values(2, 1, 'Riki', 'Agility');
insert into character(thing_id, platform_id, character_name, attribute) values(3, 1, 'Pudge', 'Force');
--способы оплаты клиента и баланс
insert into paymentmethod(customer_nick_name, credentials, paymentmethod_name, paymentmethod_type, customer_balance) values('Lexa2010','21124412421','Sberbank','Credit card', 28345);
insert into paymentmethod(customer_nick_name, credentials, paymentmethod_name, paymentmethod_type, customer_balance) values('DimasMashina','21122312421','Yandex.Money','Yandex.Money', 31345);
insert into paymentmethod(customer_nick_name, credentials, paymentmethod_name, paymentmethod_type, customer_balance) values('sixteen','21176542421','Sberbank','Credit card', 8345);
insert into paymentmethod(customer_nick_name, credentials, paymentmethod_name, paymentmethod_type, customer_balance) values('vedroid','21124413421','Citybank','Credit card', 18345);
insert into paymentmethod(customer_nick_name, credentials, paymentmethod_name, paymentmethod_type, customer_balance) values('VladKrutisna2','21127653421','Qiwi','QIWI', 4345);

-- сообщения 
insert into message(sender_nick, recipient_nick, content, send_time) values('Lexa2010', 'DimasMashina', 'Привет, как сам?','2020-12-19 10:23:54');
insert into message(sender_nick, recipient_nick, content, send_time) values('DimasMashina', 'Lexa2010', 'Ку, норм. А ты ?','2020-12-19 10:24:20');
insert into message(sender_nick, recipient_nick, content, send_time) values('Lexa2010', 'DimasMashina', 'Не хочешь снизить цену на своего крысюка? У тебя уже месяц никто не покупает','2020-12-19 10:25:54');
insert into message(sender_nick, recipient_nick, content, send_time) values('DimasMashina', 'Lexa2010', 'Не, у меня не горит, могу подождать','2020-12-19 10:26:54');
--транзакции
insert into transaction(first_customer_nick , sec_customer_nick , first_thing_id, sec_thing_id, platform_id, transaction_type  ) values('DimasMashina', 'Lexa2010', 1, null, 1, 'Sale');

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

--Тригер устанавливающий время отправки сообщения

CREATE OR REPLACE FUNCTION message_time_proc()
RETURNS trigger AS $$
    begin
       new.send_time = CURRENT_TIMESTAMP;
       return new;
    end;
 $$ LANGUAGE plpgsql;

create trigger message_time_trigger before insert on message FOR EACH ROW EXECUTE PROCEDURE message_time_proc();


--Тригер инкрементирующий атрибут транзакций рейтинга

CREATE OR REPLACE FUNCTION transaction_proc()
RETURNS trigger AS $$
    declare 
        firstUserTransact INT;
        firstUserRatingID INT;
        secUserTransact INT;
        secUserRatingID INT; 

    begin
        select rating_id into firstUserRatingID  from customer where customer_nick_name = new.first_customer_nick;
        select rating_id into secUserRatingID from customer where customer_nick_name = new.sec_customer_nick;
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
        return new;
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

--create index "customer_id_index" on customer using hash("customer_id");

create view things_view
as  select t.thing_id, t.thing_name, t.rarity, cha.character_name, t.price
    from thing t join character cha using(thing_id) where t.is_selling = true;




CREATE OR REPLACE FUNCTION  thing_info (thing_id_find integer) returns table(thing_id integer, customer_id integer, trading_platform_id integer, is_selling boolean, rarity rarities, thing_name varchar(32), price integer) as $$
begin
    return query select * from thing t where thing_id_find = t.thing_id;
end;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION  message_info_sendler_recipient (originator_nick varchar, addressee_nick varchar) returns table(sender_nick varchar,recipient_nick varchar, content varchar, send_time timestamp ) as $$
begin
    return query select m.sender_nick, m.recipient_nick, m.content, m.send_time from message m where ((originator_nick = m.sender_nick) and (addressee_nick = m.recipient_nick)) or ((addressee_nick = m.sender_nick) and (originator_nick = m.recipient_nick));
end;
$$ LANGUAGE plpgsql;  



CREATE OR REPLACE FUNCTION  customer_contacts (customer_nick varchar) returns table(people_nick varchar) as $$
begin
    return query select distinct sender_nick from message m where customer_nick = recipient_nick 
            union select distinct recipient_nick from message m where customer_nick = sender_nick;
end;
$$ LANGUAGE plpgsql;  





CREATE OR REPLACE FUNCTION  customer_information (customer_nick varchar) returns table(customer_id integer, age integer,  customer_nick_name varchar, customer_name varchar,  customer_last_name varchar, link_photo  varchar, rating_num integer, credentials varchar, paymentmethod_type paymentmethod_types, customer_balance integer) as $$
begin
    return query select c.customer_id, c.age, c.customer_nick_name, c.customer_name, c.customer_last_name, a.link_photo, r.rating_num, p.credentials, p.paymentmethod_type, p.customer_balance from customer c join rating r using (rating_id) join avatar a using(avatar_id) join paymentmethod p using(customer_nick_name) where c.customer_nick_name = customer_nick;
end;
$$ LANGUAGE plpgsql;  

CREATE OR REPLACE FUNCTION  buy_thing (first_customer_nick varchar, selling_thing_id integer) returns void as $$
declare
    enough_money boolean;
    buyer_money integer;
    thing_price integer;

begin
    select price into thing_price from thing t where t.thing_id = selling_thing_id;
    select p.customer_balance into buyer_money from customer c join paymentmethod p using(customer_nick_name) where first_customer_nick = c.customer_nick_name;
    if (buyer_money >= thing_price) then
        UPDATE thing t SET customer_nick_name = first_customer_nick, is_selling = false WHERE t.thing_id = selling_thing_id;
        UPDATE paymentmethod p SET customer_balance = (buyer_money - thing_price) WHERE p.customer_nick_name = first_customer_nick;
        insert into transaction(first_customer_nick , sec_customer_nick , first_thing_id, sec_thing_id, platform_id, transaction_type  ) values(first_customer_nick, null, selling_thing_id, null, 1, 'Sale');
    end if;
end;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION  put_up_for_sale (nick_name varchar,selling_thing_id integer) returns void as $$
declare
seller_money integer;
thing_price integer;

begin
    select price into thing_price from thing t where t.thing_id = selling_thing_id;
    select p.customer_balance into seller_money from customer c join paymentmethod p using(customer_nick_name) where nick_name = c.customer_nick_name;
    UPDATE thing t SET is_selling = true, customer_nick_name = null WHERE t.thing_id = selling_thing_id;
    UPDATE paymentmethod p SET customer_balance = (seller_money + thing_price) WHERE p.customer_nick_name = nick_name;
    insert into transaction(first_customer_nick , sec_customer_nick , first_thing_id, sec_thing_id, platform_id, transaction_type  ) values (null, nick_name, selling_thing_id, null, 1, 'Sale');

end;
$$ LANGUAGE plpgsql;  


CREATE OR REPLACE FUNCTION  remove_for_sale (selling_thing_id integer) returns void as $$
begin
    UPDATE thing t SET is_selling = false WHERE t.id = selling_thing_id;
end;
$$ LANGUAGE plpgsql; 


CREATE OR REPLACE FUNCTION  register (avatar_id integer, customer_name varchar, customer_last_name varchar, customer_nick varchar, age integer ) returns void as $$
declare
new_rating_id integer;
begin
    insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(0, 0,null ,0);
    SELECT currval('rating_id') into new_rating_id from rating;
    insert into customer(avatar_id , rating_id, platform_id, customer_name, customer_last_name, customer_nick_name, age, become_offline_time) values(avatar_id, new_rating_id, 1,  customer_name, customer_last_name, customer_nick, age, null );
end;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION  customer_things (customer_nick varchar) returns  table(is_selling boolean, thing_id integer, think_name varchar, rarity rarities, customer_nick_name varchar, character_name varchar, price integer) as $$
begin
    return query select t.is_selling, t.thing_id, t.thing_name, t.rarity, cus.customer_nick_name, cha.character_name, t.price from thing t join customer cus using(customer_nick_name) join character cha using(thing_id) where t.is_selling = false and cus.customer_nick_name = customer_nick;
end;
$$ LANGUAGE plpgsql;

--не уверен что работает
CREATE OR REPLACE FUNCTION  register (link_photo varchar, customer_name varchar, customer_last_name varchar, customer_nick varchar, age integer ) returns void as $$
declare
new_rating_id integer;
begin
    insert into rating(rating_num, transactions_num, time_decrease_const, offense_num) values(0, 0, 7,0);
    SELECT currval('rating_id_seq') into new_rating_id;
    insert into customer(avatar_id , rating_id, platform_id, customer_name, customer_last_name, customer_nick_name, age, become_offline_time) values(avatar_id, new_rating_id, 1,  customer_name, customer_last_name, customer_nick, age, null );
end;
$$ LANGUAGE plpgsql;



UPDATE paymentmethod t SET customer_balance =3999999 WHERE paymentmethod.customer_nick = 'никнейм';


drop FUNCTION thing_info(integer);
drop FUNCTION customer_information(varchar);
drop FUNCTION user_comunication_info(varchar);
drop FUNCTION message_info_sendler_recipient(varchar,varchar);
drop FUNCTION message_info(integer);

drop table trading_platform cascade;
drop table avatar cascade;
drop table rating cascade;
drop table paymentmethod cascade;
drop table customer cascade;
drop table thing cascade;
drop table bonus cascade;
drop table character cascade;
drop table customer_paymentmethod cascade;
drop table message cascade;
drop table transaction cascade;

