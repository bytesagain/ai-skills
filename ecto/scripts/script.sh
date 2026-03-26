#!/bin/bash
# Ecto - Elixir Database Toolkit Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ECTO REFERENCE                                 ║
║          Elixir Database Wrapper and Query Language          ║
╚══════════════════════════════════════════════════════════════╝

Ecto is the database toolkit for Elixir. It provides schemas,
changesets for data validation, a composable query DSL, migrations,
and multi-database support.

KEY COMPONENTS:
  Schema       Map database tables to Elixir structs
  Changeset    Validate and cast data before DB operations
  Query        Composable, type-safe query DSL
  Repo         Database interaction layer (insert/update/delete)
  Migration    Version-controlled schema changes
  Multi        Multi-tenancy and dynamic repos

ECTO vs ACTIVERECORD vs SQLALCHEMY:
  ┌──────────────┬──────────┬────────────┬───────────┐
  │ Feature      │ Ecto     │ ActiveRec. │ SQLAlchemy│
  ├──────────────┼──────────┼────────────┼───────────┤
  │ Language     │ Elixir   │ Ruby       │ Python    │
  │ Pattern      │ Repo     │ Active Rec │ Unit of W │
  │ Validation   │ Changeset│ Model      │ Marshmall.│
  │ Query DSL    │ Macro    │ Method     │ Expression│
  │ Immutable    │ Yes      │ No         │ No        │
  │ Composable   │ Excellent│ Good       │ Good      │
  │ Explicit     │ Very     │ Implicit   │ Explicit  │
  └──────────────┴──────────┴────────────┴───────────┘

INSTALL:
  # mix.exs
  defp deps do
    [
      {:ecto_sql, "~> 3.11"},
      {:postgrex, "~> 0.18"},    # PostgreSQL
      # {:myxql, "~> 0.6"},     # MySQL
      # {:ecto_sqlite3, "~> 0.15"}, # SQLite
    ]
  end

  mix ecto.create    # Create database
  mix ecto.migrate   # Run migrations
EOF
}

cmd_schema() {
cat << 'EOF'
SCHEMAS & CHANGESETS
======================

SCHEMA:
  defmodule MyApp.User do
    use Ecto.Schema
    import Ecto.Changeset

    schema "users" do
      field :name, :string
      field :email, :string
      field :age, :integer
      field :active, :boolean, default: true
      field :role, Ecto.Enum, values: [:admin, :user, :moderator]
      field :metadata, :map
      field :tags, {:array, :string}, default: []

      has_many :posts, MyApp.Post
      belongs_to :organization, MyApp.Organization
      many_to_many :teams, MyApp.Team, join_through: "users_teams"

      timestamps()  # inserted_at, updated_at
    end

    def changeset(user, attrs) do
      user
      |> cast(attrs, [:name, :email, :age, :role, :tags])
      |> validate_required([:name, :email])
      |> validate_format(:email, ~r/@/)
      |> validate_length(:name, min: 2, max: 100)
      |> validate_number(:age, greater_than: 0, less_than: 150)
      |> validate_inclusion(:role, [:admin, :user, :moderator])
      |> unique_constraint(:email)
      |> validate_change(:email, fn :email, email ->
           if String.contains?(email, "+"), do: [email: "no plus addressing"], else: []
         end)
    end

    def registration_changeset(user, attrs) do
      user
      |> changeset(attrs)
      |> cast(attrs, [:password])
      |> validate_required([:password])
      |> validate_length(:password, min: 8)
      |> put_password_hash()
    end
  end

CHANGESET USAGE:
  # Create
  changeset = User.changeset(%User{}, %{name: "Alice", email: "alice@example.com"})
  changeset.valid?   # true or false
  changeset.errors   # [email: {"is invalid", []}]

  # Insert
  case Repo.insert(changeset) do
    {:ok, user} -> # success
    {:error, changeset} -> # validation failed, inspect changeset.errors
  end

  # Update
  user = Repo.get!(User, 1)
  changeset = User.changeset(user, %{name: "Alice Updated"})
  Repo.update(changeset)

EMBEDDED SCHEMAS:
  defmodule MyApp.Address do
    use Ecto.Schema
    embedded_schema do
      field :street, :string
      field :city, :string
      field :zip, :string
    end
  end

  # In parent schema:
  embeds_one :address, MyApp.Address
  embeds_many :phone_numbers, MyApp.Phone
EOF
}

cmd_queries() {
cat << 'EOF'
QUERIES
=========

  import Ecto.Query

BASIC:
  # All users
  Repo.all(User)

  # Get by ID
  Repo.get(User, 1)       # nil if not found
  Repo.get!(User, 1)      # raises if not found

  # Get by field
  Repo.get_by(User, email: "alice@example.com")

WHERE:
  from(u in User, where: u.active == true)
  |> Repo.all()

  from(u in User,
    where: u.age > 18 and u.role == :admin,
    order_by: [desc: u.inserted_at],
    limit: 10,
    select: %{name: u.name, email: u.email}
  )
  |> Repo.all()

COMPOSABLE QUERIES:
  def active(query) do
    from u in query, where: u.active == true
  end

  def by_role(query, role) do
    from u in query, where: u.role == ^role
  end

  def recent(query, days) do
    cutoff = DateTime.utc_now() |> DateTime.add(-days * 86400)
    from u in query, where: u.inserted_at > ^cutoff
  end

  # Compose!
  User
  |> active()
  |> by_role(:admin)
  |> recent(30)
  |> Repo.all()

JOINS:
  from(p in Post,
    join: u in assoc(p, :author),
    where: u.name == "Alice",
    preload: [author: u]
  )
  |> Repo.all()

  # Left join
  from(u in User,
    left_join: p in assoc(u, :posts),
    group_by: u.id,
    select: {u.name, count(p.id)}
  )
  |> Repo.all()

AGGREGATES:
  Repo.aggregate(User, :count)
  Repo.aggregate(User, :avg, :age)

  from(u in User,
    group_by: u.role,
    select: {u.role, count(u.id), avg(u.age)}
  )
  |> Repo.all()

PRELOADING:
  # Separate queries
  user = Repo.get!(User, 1) |> Repo.preload(:posts)

  # Join preload (single query)
  from(u in User, preload: [posts: :comments])
  |> Repo.all()

SUBQUERIES:
  active_users = from(u in User, where: u.active, select: u.id)
  from(p in Post, where: p.author_id in subquery(active_users))
  |> Repo.all()

FRAGMENTS (raw SQL):
  from(u in User,
    where: fragment("lower(?)", u.email) == ^email,
    select: fragment("date_trunc('month', ?)", u.inserted_at)
  )
  |> Repo.all()

UPSERT:
  Repo.insert(%User{email: "alice@example.com", name: "Alice"},
    on_conflict: [set: [name: "Alice Updated"]],
    conflict_target: :email
  )
EOF
}

cmd_migrations() {
cat << 'EOF'
MIGRATIONS & OPERATIONS
==========================

GENERATE:
  mix ecto.gen.migration create_users

MIGRATION FILE:
  defmodule MyApp.Repo.Migrations.CreateUsers do
    use Ecto.Migration

    def change do
      create table(:users) do
        add :name, :string, null: false
        add :email, :string, null: false
        add :age, :integer
        add :active, :boolean, default: true
        add :role, :string, default: "user"
        add :metadata, :map, default: %{}
        add :organization_id, references(:organizations, on_delete: :nilify_all)
        timestamps()
      end

      create unique_index(:users, [:email])
      create index(:users, [:organization_id])
      create index(:users, [:role, :active])
    end
  end

ALTER TABLE:
  def change do
    alter table(:users) do
      add :avatar_url, :string
      modify :name, :string, null: false, from: :string
      remove :deprecated_field
    end
  end

COMMANDS:
  mix ecto.create              # Create database
  mix ecto.drop                # Drop database
  mix ecto.migrate             # Run pending migrations
  mix ecto.rollback            # Rollback last migration
  mix ecto.rollback --step 3   # Rollback 3 migrations
  mix ecto.reset               # Drop + create + migrate
  mix ecto.gen.migration name  # Generate migration file

TRANSACTIONS:
  Repo.transaction(fn ->
    user = Repo.insert!(%User{name: "Alice", email: "a@b.com"})
    Repo.insert!(%Post{title: "First", author_id: user.id})
    user
  end)

  # With Ecto.Multi (composable transactions)
  Ecto.Multi.new()
  |> Ecto.Multi.insert(:user, User.changeset(%User{}, user_attrs))
  |> Ecto.Multi.insert(:post, fn %{user: user} ->
       Post.changeset(%Post{}, %{title: "First", author_id: user.id})
     end)
  |> Repo.transaction()
  |> case do
       {:ok, %{user: user, post: post}} -> # success
       {:error, :user, changeset, _} -> # user insert failed
     end

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Ecto - Elixir Database Toolkit Reference

Commands:
  intro       Overview, components, comparison
  schema      Schemas, changesets, validation
  queries     Query DSL, joins, preloading, composable
  migrations  Migrations, transactions, Ecto.Multi

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  schema)     cmd_schema ;;
  queries)    cmd_queries ;;
  migrations) cmd_migrations ;;
  help|*)     show_help ;;
esac
