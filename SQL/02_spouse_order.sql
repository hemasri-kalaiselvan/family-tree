-- Run once in the Supabase SQL editor BEFORE using the new field
alter table public.ft_marriages add column if not exists spouse_order numeric null;

-- let the app read it (same access as the other marriage fields)
insert into public.ft_field_access (table_name, column_name, min_role)
values ('ft_marriages', 'spouse_order', 'public')
on conflict (table_name, column_name) do nothing;
