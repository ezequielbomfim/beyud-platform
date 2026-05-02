CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(150) NOT NULL,
    email VARCHAR(200) NOT NULL,
    company VARCHAR(200),
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    processed_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_contacts_status
ON contacts(status);

INSERT INTO contacts (
    name,
    email,
    company,
    subject,
    message,
    status
)
VALUES (
    'Contato inicial BEYUD',
    'contact@beyud.local',
    'BEYUD Platform',
    'Registro inicial',
    'Contato criado automaticamente na inicialização do banco local.',
    'PENDING'
)
ON CONFLICT DO NOTHING;