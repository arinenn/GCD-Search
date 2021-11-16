program search_nod;
type
    num_t = array [1..2000] of integer;
    num_and_info_t = record
                        look: num_t;
                        length: integer;
                        system: 2..70
                    end;
    division_t = record
                    int_part: num_and_info_t;
                    remainder: num_and_info_t
                end;
var
    num_A, num_B, num_C: num_and_info_t;
    s1, s2, s3, max_sys, control, check: integer;
    symbol: char;
    i: integer;

{Перевод из символа в число}
function Char_to_dig(sym: char): integer;
var pr: integer;
begin
    pr:=70;
    if (ord(symbol) = 4) or (ord(symbol) = 26) then
        if (num_A.length=0) or (num_B.length=0) then
        begin
            writeln('WRONG INPUT: NOT ENOUGH NUMBERS');
            Halt(0)
        end
        else pr:=71;
    if ((ord(symbol) = 13) or (ord(symbol) = 9)
     or (ord(symbol) = 32) or (ord(symbol) = 10)) then pr:=71;
    case sym of
    '0': pr := 0;  '1': pr := 1;  '2': pr := 2;  '3': pr := 3;  '4': pr :=  4;
    '5': pr := 5;  '6': pr := 6;  '7': pr := 7;  '8': pr := 8;  '9': pr :=  9;
    'a': pr := 10; 'b': pr := 11; 'c': pr := 12; 'd': pr := 13; 'e': pr := 14;
    'f': pr := 15; 'g': pr := 16; 'h': pr := 17; 'i': pr := 18; 'j': pr := 19;
    'k': pr := 20; 'l': pr := 21; 'm': pr := 22; 'n': pr := 23; 'o': pr := 24;
    'p': pr := 25; 'q': pr := 26; 'r': pr := 27; 's': pr := 28; 't': pr := 29;
    'u': pr := 30; 'v': pr := 31; 'w': pr := 32; 'x': pr := 33; 'y': pr := 34;
    'z': pr := 35; 'A': pr := 36; 'B': pr := 37; 'C': pr := 38; 'D': pr := 39;
    'E': pr := 40; 'F': pr := 41; 'G': pr := 42; 'H': pr := 43; 'I': pr := 44;
    'J': pr := 45; 'K': pr := 46; 'L': pr := 47; 'M': pr := 48; 'N': pr := 49;
    'O': pr := 50; 'P': pr := 51; 'Q': pr := 52; 'R': pr := 53; 'S': pr := 54;
    'T': pr := 55; 'U': pr := 56; 'V': pr := 57; 'W': pr := 58; 'X': pr := 59;
    'Y': pr := 60; 'Z': pr := 61; '!': pr := 62; '@': pr := 63; '#': pr := 64;
    '$': pr := 65; '%': pr := 66; '^': pr := 67; '&': pr := 68; '*': pr := 69;
    end;
    Char_to_dig := pr
end;

{Перевод из разряда в число}
function Dig_to_char(X: integer): char;
var pr: char;
begin
    case X of
    0:  pr := '0'; 1:  pr := '1'; 2:  pr := '2';  3: pr := '3'; 4:  pr := '4';
    5:  pr := '5'; 6:  pr := '6'; 7:  pr := '7';  8: pr := '8'; 9:  pr := '9';
    10: pr := 'a'; 11: pr := 'b'; 12: pr := 'c'; 13: pr := 'd'; 14: pr := 'e';
    15: pr := 'f'; 16: pr := 'g'; 17: pr := 'h'; 18: pr := 'i'; 19: pr := 'j';
    20: pr := 'k'; 21: pr := 'l'; 22: pr := 'm'; 23: pr := 'n'; 24: pr := 'o';
    25: pr := 'p'; 26: pr := 'q'; 27: pr := 'r'; 28: pr := 's'; 29: pr := 't';
    30: pr := 'u'; 31: pr := 'v'; 32: pr := 'w'; 33: pr := 'x'; 34: pr := 'y';
    35: pr := 'z'; 36: pr := 'A'; 37: pr := 'B'; 38: pr := 'C'; 39: pr := 'D';
    40: pr := 'E'; 41: pr := 'F'; 42: pr := 'G'; 43: pr := 'H'; 44: pr := 'I';
    45: pr := 'J'; 46: pr := 'K'; 47: pr := 'L'; 48: pr := 'M'; 49: pr := 'N';
    50: pr := 'O'; 51: pr := 'P'; 52: pr := 'Q'; 53: pr := 'R'; 54: pr := 'S';
    55: pr := 'T'; 56: pr := 'U'; 57: pr := 'V'; 58: pr := 'W'; 59: pr := 'X';
    60: pr := 'Y'; 61: pr := 'Z'; 62: pr := '!'; 63: pr := '@'; 64: pr := '#';
    65: pr := '$'; 66: pr := '%'; 67: pr := '^'; 68: pr := '&'; 69: pr := '*';
    end;
    Dig_to_char := pr
end;

{Показать число}
procedure Show_number(number_A: num_and_info_t);
var i: integer;
begin
    for i:=1 to number_A.length do write(Dig_to_char(number_A.look[i]));
    writeln
end;

{Сравнение чисел ( A > B / A < B / A = B)}
function Compare(number_A, number_B: num_and_info_t): integer;
var number_X, number_Y, i: integer;
begin
    number_X := number_A.length;
    number_Y := number_B.length;
    if number_X > number_Y then Compare := 1 else
        if number_X < number_Y then Compare := 0 else
        begin
            for i:=1 to number_X do
            begin
                if number_A.look[i] > number_B.look[i] then
                begin
                    Compare := 1; break
                end;
                if number_A.look[i] < number_B.look[i] then
                begin
                    Compare := 0; break
                end;
                Compare := 2
            end
        end
end;

{Проверка на нуль}
function Compare_null(number_A: num_and_info_t): boolean;
begin
    if number_A.length<>1
        then Compare_null:=false
    else
        if number_A.look[1]<>0
            then Compare_null:=false
        else Compare_null:=true
end;

{Сложение чисел в одинаковой СС}
function Add(number_A, number_B: num_and_info_t): num_and_info_t;
var
    shorter_number, longer_number, rev_number: num_t;
    sys, len_A, len_B, i, head, max_length: integer;
begin
    sys := number_A.system;
    len_A := number_A.length;
    len_B := number_B.length;
{Добавление незначащих нулей}
    if len_A > len_B then
    begin
        max_length := len_A;
        longer_number := number_A.look;
        for i:=1 to len_A - len_B do
            shorter_number[i]:=0;
        for i:=1 to len_B do
            shorter_number[i + (len_A - len_B)] := number_B.look[i]
    end
    else if len_A < len_B then
    begin
        max_length := len_B;
        longer_number := number_B.look;
        for i:=1 to len_B - len_A do
            shorter_number[i]:=0;
        for i:=1 to len_A do
            shorter_number[i + (len_B - len_A)]:=number_A.look[i]
    end
    else
    begin
        max_length:=len_A;
        longer_number:=number_A.look;
        shorter_number:=number_B.look;
    end;
{Поразрядное сложение чисел}
    head:=0;
    for i:=1 to max_length do begin
        rev_number[i] := longer_number[max_length-i+1]
                        + shorter_number[max_length-i+1]
                        + head;
        head:=0;
        if rev_number[i]>=sys then begin
            head:=head+1;
            rev_number[i]:=rev_number[i]-sys;
        end
    end;
    if head<>0 then begin
        max_length:=max_length+1;
        rev_number[max_length]:=head;
    end;
{Заполнение ответа}
    for i:=1 to max_length do
        Add.look[max_length-i+1]:=rev_number[i];
    with Add do begin
        length:=max_length;
        system:=sys;
    end
end;

{Умножение числа в его СС на однозначное число в этой СС}
function Multiply_by(number_A: num_and_info_t; multiplier: integer): num_and_info_t;
var rev_number: num_t;
    i, head, x, sys: integer;
begin
{Проверка на нуль}
    if multiplier<>0 then begin
    {Умножение в столбик}
        x:=number_A.length; sys:=number_A.system;
        head:=0;
        for i:=1 to x do
        begin
            rev_number[i]:=number_A.look[x-i+1]*multiplier+head;
            head:=0;
            if rev_number[i]>=sys then
            begin
                head := rev_number[i] div sys;
                rev_number[i] := rev_number[i] mod sys
            end
        end;
    {Проверка на изменение длины}
        while head<>0 do begin
            x:=x+1;
            rev_number[x]:=head;
            head:=0;
            if rev_number[x]>=sys then begin
                head:=rev_number[x] div sys;
                rev_number[x]:=rev_number[x] mod sys
            end
        end;
        for i:=1 to x do
            Multiply_by.look[x-i+1]:=rev_number[i]
        end
    else
        begin
        Multiply_by.look[1]:=0;
        x:=1;
        sys:=number_A.system;
        end;
    with Multiply_by do
        begin
            length:=x;
            system:=sys
        end
end;

{Перевод числа из меньшей СС в большую СС}
function Trans_bigger(number_A: num_and_info_t; sys_big: integer): num_and_info_t;
var
    new, degree: num_and_info_t;
    i, x, sys, digit: integer;
begin
    x:=number_A.length; sys:=number_A.system;
{Создание чисел для счёта}
    with new do begin
        look[1]:=number_A.look[x];
        length:=1;
        system:=sys_big
    end;
    with degree do begin
        look[1]:=1;
        length:=1;
        system:=sys_big
    end;
{Непосредственно перевод}
    for i:=2 to x do
    begin
        degree:=Multiply_by(degree, sys);
        digit:=number_A.look[x-i+1];
        new:=Add(new, Multiply_by(degree, digit));
    end;
    Trans_bigger:=new;
end;

{Вычитание из большего числа в одной СС}
function Substract(number_A, number_B: num_and_info_t): num_and_info_t;
var bigger_number, smaller_number, rev_number: num_t;
    i, j, len_A, len_B, sys, schet, max_length, dif: integer;
begin
    len_A:=number_A.length;
    len_B:=number_B.length;
    sys:=number_A.system;
{Добавление незначащих нулей}
    bigger_number:=number_A.look;
    for i:=1 to len_A-len_B do smaller_number[i]:=0;
    for i:=1 to len_B do smaller_number[i+(len_A-len_B)]:=number_B.look[i];
{Непосредственно разность}
    max_length:=len_A;
    for i:=1 to max_length do
    begin
        schet:=bigger_number[max_length-i+1]-smaller_number[max_length-i+1];
        if schet >= 0 then
            rev_number[i]:=schet
        else {Взять разряд}
            begin
                j:=max_length-i;
            {Если цифра = нулю}
                while bigger_number[j] = 0 do
                begin
                    bigger_number[j] := sys - 1;
                    j := j - 1
                end;
            {Если цифра <> нулю}
                bigger_number[j] := bigger_number[j] - 1;
                rev_number[i] := schet + sys
            end
    end;
{Проверка на изменение длины по сравнению с большим числом}
    dif:=0;
    for i:=max_length downto 1 do
    begin
        if rev_number[i]=0 then
            dif:=dif+1
        else
            break
    end;
    max_length:=max_length-dif;
{Заполнение ответа}
    for i:=1 to max_length do
        Substract.look[max_length-i+1]:=rev_number[i];
    with Substract do
    begin
        length:=max_length;
        system:=sys
    end
end;

{Промежуточное деление чисел в одной СС}
function Divide_small(number_A, number_B: num_and_info_t): division_t;
var
    bigger_number, smaller_number, whole_part, ostatok, one: num_and_info_t;
    sys: integer;
begin
if Compare(number_A, number_B)<>0 then
begin
    sys:=number_A.system;
    bigger_number:=number_A;
{Создание чисел для счёта}
    with smaller_number do
    begin
        look[1]:=0;
        length:=1;
        system:=sys
    end;
    whole_part:=smaller_number;
    one:=whole_part; one.look[1]:=1;
{Счёт целой части (сложение, пока не превзойдёт)}
    repeat
    begin
        smaller_number:=Add(smaller_number, number_B);
        whole_part:=Add(whole_part, one);
    end
    until Compare(bigger_number, smaller_number)<>1;
{Счёт остатка, заполнение ответа}
    if Compare(bigger_number, smaller_number)=2 then
        with ostatok do
        begin
            look[1]:=0;
            length:=1;
            system:=sys
        end
    else
    begin
        whole_part:=Substract(whole_part, one);
        smaller_number:=Substract(smaller_number, number_B);
        ostatok:=Substract(bigger_number, smaller_number)
    end;
    with Divide_small do
    begin
        int_part:=whole_part;
        remainder:=ostatok
    end;
end
else
    with Divide_small do
    begin
        int_part.look[1]:=0;
        int_part.length:=1;
        int_part.system:=number_A.system;
        remainder:=number_A
    end
end;

{Деление длинного числа на короткое в одной СС}
function Divide(number_A, number_B: num_and_info_t): division_t;
var
    logged_num, prom_whole: num_and_info_t;
    prom: division_t;
    i, j, k, sys, max_length, min_length: integer;
begin
if Compare(number_A, number_B)<>0 then
begin
    sys:=number_A.system;
    max_length:=number_A.length;
    min_length:=number_B.length;
{Создать непревышающую последовательность}
    with logged_num do
    begin
        length:=0;
        system:=sys
    end;
    for i:=1 to min_length do
    begin
        logged_num.look[i]:=number_A.look[i];
        logged_num.length:=logged_num.length+1
    end;
    if Compare(logged_num, number_B)=0 then
    begin
        i:=i+1;
        logged_num.look[i]:=number_A.look[i];
        logged_num.length:=logged_num.length+1
    end;
{Начало деления}
    prom_whole.system:=sys;
    prom_whole.length:=0;
    k:=0;
    for j:=i to max_length do
    begin
        k:=k+1;
    {Сохранение k-го разряда (с начала) целой части}
        prom:=Divide_small(logged_num, number_B);
        prom_whole.look[k]:=prom.int_part.look[1];
        prom_whole.length:=prom_whole.length+1;
        logged_num:=prom.remainder;
    {Сносим разряд}
        if j<max_length then
            if logged_num.look[1]=0 then
                logged_num.look[1]:=number_A.look[j+1]
            else
            begin
                logged_num.look[logged_num.length+1]:=number_A.look[j+1];
                logged_num.length:=logged_num.length+1
            end;
    end;
{Заполнение ответа}
    with Divide do
    begin
        int_part:=prom_whole;
        remainder:=logged_num
    end
end
else
    with Divide do
    begin
        int_part.look[1]:=0;
        int_part.length:=1;
        int_part.system:=number_A.system;
        remainder:=number_A
    end
end;

{Нахождение НОД-ля для чисел в одной СС}
function Euclidus(number_A, number_B: num_and_info_t): num_and_info_t;
begin
    while (not Compare_null(number_A)) and (not Compare_null(number_B)) do
        if Compare(number_A, number_B)=1 then
            number_A:=Divide(number_A, number_B).remainder
        else
            number_B:=Divide(number_B, number_A).remainder;
    Euclidus:=Add(number_A, number_B)
end;

{Первод из большей СС в меньшую СС}
function Trans_smaller(number_A: num_and_info_t; sys: integer): num_and_info_t;
var
    prom: division_t;
    rev_number, divider, divisible: num_and_info_t;
    i, count: integer;
begin
{Создание чисел для счёта}
    divisible:=number_A;
    divider.look[1]:=sys;
    divider.length:=1;
    divider.system:=number_A.system;
    rev_number.length:=0;
    rev_number.system:=sys;
{Непосредственно перевод}
    count:=0;
    while not Compare_null(divisible) do
    begin
        count:=count+1;
        prom:=Divide(divisible, divider);
        if count <= 2000 then
            rev_number.look[count]:=prom.remainder.look[1]
        else
        begin
            writeln('ERROR: NUMBER C IS >2000 LENGTH LONG');
            Halt(0)
        end;
        divisible:=prom.int_part
    end;
{Перевернуть число, заполнить ответ}
    rev_number.length:=count;
    for i:=1 to count do
        Trans_smaller.look[count-i+1]:=rev_number.look[i];
    rev_number.look:=Trans_smaller.look;
    Trans_smaller:=rev_number;
end;

begin
control:=0;
if Paramcount < 3 then
begin
    writeln('WRONG SYSTEM: LESS THAN THREE');
    Halt(0)
end
else
    if Paramcount > 3 then
    begin
        writeln('WRONG SYSTEM: MORE THAN THREE');
        Halt(0)
    end
else
begin
{Ввод 3-х СС через консоль}
    for i:=1 to 3 do
    begin
        case i of
            1: Val(ParamStr(i), s1, control);
            2: Val(ParamStr(i), s2, control);
            3: Val(ParamStr(i), s3, control);
        end;
        if control = 1 then
        begin
            writeln('WRONG SYSTEM: NOT A NUMBER');
            Halt(0)
        end
    end;
    if (((s1<2) or (s1>70))
        or ((s2<2) or (s2>70))
        or ((s3<2) or (s3>70))) then
    begin
        writeln('WRONG SYSTEM: OUT OF RANGE');
        Halt(0)
    end
end;
num_A.system:=s1;
num_B.system:=s2;
{Ввод чисел и проверка на принадлежность к заданной СС, на длину}
{Поиск начала числа А}
control := 0;
repeat
begin
    if eof then
    begin
        writeln('WRONG INPUT: NO NUMBERS FOUND');
        Halt(0)
    end;
    read(symbol);
    check := Char_to_dig(symbol);
    if check = 70 then
    if (symbol='-') or (symbol='+') then
    begin
        if control=1 then
        begin
            writeln('WRONG INPUT: 1ST NUMBER, INCORRECT SEQUENCE'); {+- / ++ / +++++----++-}
            Halt(0)
        end;
        if control=0 then control:=1;
    end
    else
    begin
        writeln('WRONG INPUT: 1ST NUMBER, INCORRECT SYMBOL');
        Halt(0)
    end;
    if (check = 71) and (control = 1) then
    begin
        writeln('WRONG INPUT: 1ST NUMBER, LONE SIGN'); {+ / -}
        Halt(0)
    end;
end;
until check < 70;
{Считывание числа А}
i:=1; num_A.length:=0;
repeat
{Незначащие нули}
    if (symbol='0') and (num_A.length=0) then
    begin
        num_A.look[1]:=0;
        num_A.length:=1;
        repeat
            if eof then break;
            read(symbol)
        until Char_to_dig(symbol) <> 0;
        if eof then break;
    end
    else
    begin
        if num_A.look[1]=0 then num_A.length:=0;
        if Char_to_dig(symbol)=70 then
        begin
            writeln('WRONG INPUT: 1ST NUMBER, INCORRECT DIGIT');
            Halt(0)
        end
        else if Char_to_dig(symbol)>=num_A.system then
        begin
            writeln('WRONG INPUT: 1ST NUMBER, DIGIT IS NOT IN THE SYSTEM');
            Halt(0)
        end;
        num_A.look[i]:= Char_to_dig(symbol);
        num_A.length := num_A.length+1;
        if num_A.length>1000 then
        begin
            writeln('WRONG INPUT: 1ST NUMBER, LENGTH >1000');
            Halt(0)
        end;
        i:=i+1;
        if eof then break;
        read(symbol)
    end;
until Char_to_dig(symbol)=71;
if eof then
begin
    writeln('WRONG INPUT: ONLY ONE NUMBER');
    Halt(0);
end;
{Поиск начала числа B}
control := 0;
repeat
begin
    if eof then
    begin
        writeln('WRONG INPUT: ONLY ONE NUMBER');
        Halt(0)
    end;
    read(symbol);
    check := Char_to_dig(symbol);
    if check = 70 then
    if (symbol='-') or (symbol='+') then
    begin
        if control=1 then
        begin
            writeln('WRONG INPUT: 2ND NUMBER, INCORRECT SEQUENCE'); {+- / ++ / +++++----++-}
            Halt(0)
        end;
        if control=0 then control:=1;
    end
    else
    begin
        writeln('WRONG INPUT: 2ND NUMBER, INCORRECT SYMBOL');
        Halt(0)
    end;
    if (check = 71) and (control = 1) then
    begin
        writeln('WRONG INPUT: 2ND NUMBER, LONE SIGN'); {+ / -}
        Halt(0)
    end;
end;
until check < 70;
{Считывание числа B}
i:=1; num_B.length:=0;
repeat
{Незначащие нули}
    if (symbol='0') and (num_B.length=0) then
    begin
        num_B.look[1]:=0;
        num_B.length:=1;
        repeat
            if eof then break;
            read(symbol)
        until Char_to_dig(symbol) <> 0;
        if eof then break;
    end
    else
    begin
        if num_B.look[1]=0 then num_B.length:=0;
        if Char_to_dig(symbol)=70 then
        begin
            writeln('WRONG INPUT: 2ST NUMBER, INCORRECT DIGIT');
            Halt(0)
        end
        else if Char_to_dig(symbol)>=num_B.system then
        begin
            writeln('WRONG INPUT: 2ST NUMBER, DIGIT IS NOT IN THE SYSTEM');
            Halt(0)
        end;
        num_B.look[i]:= Char_to_dig(symbol);
        num_B.length := num_B.length+1;
        if num_B.length>1000 then
        begin
            writeln('WRONG INPUT: 2ST NUMBER, LENGTH >1000');
            Halt(0)
        end;
        i:=i+1;
        if eof then break;
        read(symbol);
    end;
until Char_to_dig(symbol)>69;
if Char_to_dig(symbol) = 70 then
begin
    writeln('WRONG INPUT: 2ND NUMBER, INCORRECT DIGIT');
    Halt(0)
end;
{max_sys = max(s1,s2,s3) - наиб. СС}
    if s1>s2 then max_sys:=s1 else max_sys:=s2;
    if max_sys<s3 then max_sys:=s3;
{Перевод чисел в наиб СС (если было подано два числа)}
    if max_sys = s1 then
        num_B := Trans_bigger(num_B, max_sys)
    else if max_sys=s2 then
            num_A := Trans_bigger(num_A, max_sys)
        else
        begin
            num_A := Trans_bigger(num_A, max_sys);
            num_B := Trans_bigger(num_B, max_sys)
        end;
{Счёт НОД-ля в наиб СС}
    num_C := Euclidus(num_A, num_B);
{Перевод C в s3}
    if max_sys > s3 then num_C := Trans_smaller(num_C, s3);
{Показать ответ}
    Show_number(num_C);
    writeln('FINISHED: SUCCESS');
end.
