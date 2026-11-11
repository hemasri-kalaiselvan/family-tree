-- Lets signed-out visitors see gender (needed for the blue / pink box colours)
insert into public.ft_field_access (table_name, column_name, min_role)
values ('ft_people', 'gender', 'public')
on conflict (table_name, column_name) do update set min_role = 'public';
