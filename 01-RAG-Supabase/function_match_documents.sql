
DROP FUNCTION IF EXISTS match_documents;

create or replace function public.match_documents(
  filter jsonb,
  match_count int,
  query_embedding vector
)
returns table (
  id bigint,
  content text,
  metadata jsonb,
  similarity float
)
language sql
stable
as $$
  select
    v.id,
    v.content,
    v.metadata,
    1 - (v.embedding <=> query_embedding) as similarity
  from public."rag" v -- cambiar rag por el nombre de tu tabla / replace rag with the name of your table
  order by v.embedding <=> query_embedding
  limit match_count;
$$;

-- Permisos para el rol anon (o el que uses en tu API key)
grant execute on function public.match_documents(jsonb, int, vector) to anon;
grant select on table public."rag" to anon;  -- cambiar rag por el nombre de tu tabla / replace rag with the name of your table