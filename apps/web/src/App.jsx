import { Link, Route, Routes } from 'react-router-dom'

function Home() {
  return (
    <section className="hero">
      <span className="badge">Production-style platform on AWS</span>
      <h1>BEYUD Platform</h1>
      <p>
        Plataforma pública production-style na AWS, construída com práticas reais de Cloud,
        DevOps, Kubernetes, Platform Engineering, automação e observabilidade.
      </p>
    </section>
  )
}

function Sobre() {
  return (
    <section className="card">
      <h2>Sobre</h2>
      <p>
        A BEYUD Platform foi desenhada para demonstrar uma arquitetura moderna com AWS,
        Terraform, Docker, RKE2, Rancher, GitHub Actions, Argo CD, RDS PostgreSQL,
        Prometheus, Grafana, Loki e Promtail.
      </p>
    </section>
  )
}

function Servicos() {
  const services = [
    'Cloud Infrastructure',
    'Kubernetes Platform',
    'CI/CD and GitOps',
    'Observability',
  ]

  return (
    <section className="card">
      <h2>Serviços</h2>
      <div className="grid">
        {services.map((service) => (
          <div className="service-card" key={service}>
            <h3>{service}</h3>
            <p>Componente previsto na arquitetura da BEYUD Platform.</p>
          </div>
        ))}
      </div>
    </section>
  )
}

function Contato() {
  return (
    <section className="card">
      <h2>Contato</h2>
      <form className="form">
        <input placeholder="Nome" />
        <input placeholder="E-mail" />
        <input placeholder="Empresa" />
        <input placeholder="Assunto" />
        <textarea placeholder="Mensagem" />
        <button type="button">Enviar contato</button>
      </form>
      <p className="note">
        Nesta etapa, o formulário ainda não envia dados para a API. A integração será feita depois.
      </p>
    </section>
  )
}

function Status() {
  return (
    <section className="card">
      <h2>Status</h2>
      <p>Front-end local executando com sucesso.</p>
      <ul>
        <li>beyud-web: running</li>
        <li>beyud-api: local endpoint validated</li>
        <li>beyud-worker: local simulation validated</li>
      </ul>
    </section>
  )
}

function App() {
  return (
    <div className="app">
      <header className="header">
        <strong>BEYUD Platform</strong>

        <nav>
          <Link to="/">Home</Link>
          <Link to="/sobre">Sobre</Link>
          <Link to="/servicos">Serviços</Link>
          <Link to="/contato">Contato</Link>
          <Link to="/status">Status</Link>
        </nav>
      </header>

      <main>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/sobre" element={<Sobre />} />
          <Route path="/servicos" element={<Servicos />} />
          <Route path="/contato" element={<Contato />} />
          <Route path="/status" element={<Status />} />
        </Routes>
      </main>
    </div>
  )
}

export default App