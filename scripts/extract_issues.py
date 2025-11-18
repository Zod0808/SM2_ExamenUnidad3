#!/usr/bin/env python3
"""
Script para extraer información completa de todos los issues de GitHub
Requiere: pip install PyGithub
Uso: python scripts/extract_issues.py
"""

import json
import os
from github import Github
from datetime import datetime

# Configuración
GITHUB_TOKEN = os.getenv('GITHUB_TOKEN', '')  # Configurar token en variables de entorno
REPO_OWNER = 'Sistema-de-control-de-acceso'
REPO_NAME = 'MovilesII'

def extract_issue_data(issue):
    """Extrae información detallada de un issue"""
    issue_data = {
        'number': issue.number,
        'title': issue.title,
        'state': issue.state,
        'url': issue.html_url,
        'created_at': issue.created_at.isoformat() if issue.created_at else None,
        'closed_at': issue.closed_at.isoformat() if issue.closed_at else None,
        'labels': [label.name for label in issue.labels],
        'assignees': [assignee.login for assignee in issue.assignees],
        'milestone': issue.milestone.title if issue.milestone else None,
        'body': issue.body or '',
        'user_story': '',
        'acceptance_criteria': [],
        'tasks': [],
        'story_points': '',
        'estimacion': '',
        'prioridad': '',
        'dependencias': ''
    }
    
    # Parsear el body para extraer información estructurada
    if issue.body:
        body = issue.body
        
        # Extraer User Story
        if 'User Story' in body:
            parts = body.split('User Story')
            if len(parts) > 1:
                user_story_section = parts[1].split('Acceptance Criteria')[0].strip()
                issue_data['user_story'] = user_story_section.replace('**', '').strip()
        
        # Extraer Acceptance Criteria
        if 'Acceptance Criteria' in body:
            ac_section = body.split('Acceptance Criteria')[1]
            if 'Tasks' in ac_section:
                ac_section = ac_section.split('Tasks')[0]
            elif 'Story Points' in ac_section:
                ac_section = ac_section.split('Story Points')[0]
            
            # Buscar items de lista
            lines = ac_section.split('\n')
            for line in lines:
                line = line.strip()
                if line.startswith('- [ ]') or line.startswith('- [x]') or line.startswith('*'):
                    criteria = line.replace('- [ ]', '').replace('- [x]', '').replace('*', '').strip()
                    if criteria and len(criteria) > 5:
                        issue_data['acceptance_criteria'].append(criteria)
        
        # Extraer Tasks
        if 'Tasks' in body:
            tasks_section = body.split('Tasks')[1]
            if 'Story Points' in tasks_section:
                tasks_section = tasks_section.split('Story Points')[0]
            
            lines = tasks_section.split('\n')
            for line in lines:
                line = line.strip()
                if line.startswith('- [ ]') or line.startswith('- [x]') or line.startswith('*'):
                    task = line.replace('- [ ]', '').replace('- [x]', '').replace('*', '').strip()
                    if task and len(task) > 5:
                        issue_data['tasks'].append(task)
        
        # Extraer metadata
        if 'Story Points:' in body:
            sp_match = body.split('Story Points:')[1].split('\n')[0].strip()
            issue_data['story_points'] = sp_match
        
        if 'Estimación:' in body:
            est_match = body.split('Estimación:')[1].split('\n')[0].strip()
            issue_data['estimacion'] = est_match
        
        if 'Prioridad:' in body:
            pri_match = body.split('Prioridad:')[1].split('\n')[0].strip()
            issue_data['prioridad'] = pri_match
        
        if 'Dependencias:' in body:
            dep_match = body.split('Dependencias:')[1].split('\n')[0].strip()
            issue_data['dependencias'] = dep_match
    
    return issue_data

def generate_markdown(issues_data):
    """Genera documento Markdown con todos los issues"""
    md_content = f"""# Issues Completos del Proyecto

**Fecha de revisión:** {datetime.now().strftime('%d de %B %Y')}  
**Total de Issues:** {len(issues_data)}  
**Issues Abiertos:** {sum(1 for i in issues_data if i['state'] == 'open')}  
**Issues Cerrados:** {sum(1 for i in issues_data if i['state'] == 'closed')}

---

## Índice

- [Issues Abiertos](#issues-abiertos)
- [Issues Cerrados](#issues-cerrados)
- [Estadísticas Generales](#estadísticas-generales)

---

# Issues Abiertos

"""
    
    # Issues abiertos
    open_issues = [i for i in issues_data if i['state'] == 'open']
    open_issues.sort(key=lambda x: x['number'], reverse=True)
    
    for idx, issue in enumerate(open_issues, 1):
        md_content += f"""## {idx}. [#{issue['number']}] {issue['title']}
- **Estado:** Abierto
- **URL:** {issue['url']}
- **Etiquetas:** {', '.join(issue['labels']) if issue['labels'] else 'N/A'}
- **Prioridad:** {issue['prioridad'] or 'No especificada'}
- **Story Points:** {issue['story_points'] or 'N/A'}
- **Estimación:** {issue['estimacion'] or 'N/A'}
- **Creado:** {issue['created_at'][:10] if issue['created_at'] else 'N/A'}
- **Dependencias:** {issue['dependencias'] or 'N/A'}

"""
        
        if issue['user_story']:
            md_content += f"""### User Story
{issue['user_story']}

"""
        
        if issue['acceptance_criteria']:
            md_content += """### Acceptance Criteria
"""
            for ac in issue['acceptance_criteria']:
                md_content += f"- [ ] {ac}\n"
            md_content += "\n"
        
        if issue['tasks']:
            md_content += """### Tasks
"""
            for task in issue['tasks']:
                md_content += f"- [ ] {task}\n"
            md_content += "\n"
        
        md_content += "---\n\n"
    
    # Issues cerrados
    md_content += """# Issues Cerrados

"""
    
    closed_issues = [i for i in issues_data if i['state'] == 'closed']
    closed_issues.sort(key=lambda x: x['number'], reverse=True)
    
    for idx, issue in enumerate(closed_issues, 1):
        md_content += f"""## {idx}. [#{issue['number']}] {issue['title']}
- **Estado:** Cerrado
- **URL:** {issue['url']}
- **Etiquetas:** {', '.join(issue['labels']) if issue['labels'] else 'N/A'}
- **Prioridad:** {issue['prioridad'] or 'No especificada'}
- **Story Points:** {issue['story_points'] or 'N/A'}
- **Creado:** {issue['created_at'][:10] if issue['created_at'] else 'N/A'}
- **Cerrado:** {issue['closed_at'][:10] if issue['closed_at'] else 'N/A'}

"""
        
        if issue['user_story']:
            md_content += f"""### User Story
{issue['user_story']}

"""
        
        if issue['acceptance_criteria']:
            md_content += """### Acceptance Criteria
"""
            for ac in issue['acceptance_criteria']:
                md_content += f"- [x] {ac}\n"
            md_content += "\n"
        
        if issue['tasks']:
            md_content += """### Tasks
"""
            for task in issue['tasks']:
                md_content += f"- [x] {task}\n"
            md_content += "\n"
        
        md_content += "---\n\n"
    
    # Estadísticas
    md_content += """# Estadísticas Generales

## Por Estado
"""
    md_content += f"- **Abiertos:** {len(open_issues)}\n"
    md_content += f"- **Cerrados:** {len(closed_issues)}\n"
    md_content += f"- **Tasa de Completitud:** {(len(closed_issues)/len(issues_data)*100):.1f}%\n\n"
    
    md_content += """## Por Prioridad
"""
    priorities = {}
    for issue in issues_data:
        pri = issue['prioridad'] or 'No especificada'
        priorities[pri] = priorities.get(pri, 0) + 1
    
    for pri, count in sorted(priorities.items()):
        md_content += f"- **{pri}:** {count}\n"
    
    md_content += f"\n---\n\n**Última actualización:** {datetime.now().strftime('%d de %B %Y')}\n"
    md_content += "**Generado automáticamente con:** `scripts/extract_issues.py`\n"
    
    return md_content

def main():
    """Función principal"""
    # Intentar con token si está disponible, sino usar API pública (con limitaciones)
    if GITHUB_TOKEN:
        print("Usando token de GitHub para acceso completo...")
        g = Github(GITHUB_TOKEN)
    else:
        print("ADVERTENCIA: No se encontro GITHUB_TOKEN. Intentando acceso publico (puede tener limitaciones de rate)...")
        print("   Para mejor rendimiento, configura: $env:GITHUB_TOKEN='tu_token' (PowerShell)")
        g = Github()  # Sin token, acceso público con limitaciones
    
    try:
        repo = g.get_repo(f"{REPO_OWNER}/{REPO_NAME}")
        
        print(f"Extrayendo issues de {REPO_OWNER}/{REPO_NAME}...")
        
        # Obtener todos los issues (abiertos y cerrados)
        all_issues = repo.get_issues(state='all')
        
        issues_data = []
        for issue in all_issues:
            # Saltar pull requests
            if issue.pull_request:
                continue
            
            print(f"Procesando issue #{issue.number}...")
            issue_data = extract_issue_data(issue)
            issues_data.append(issue_data)
        
        print(f"\nTotal de issues procesados: {len(issues_data)}")
        
        # Generar markdown
        md_content = generate_markdown(issues_data)
        
        # Guardar archivo
        output_file = 'docs/ISSUES_COMPLETO.md'
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(md_content)
        
        print(f"\nDocumento generado: {output_file}")
        
        # También guardar JSON para referencia
        json_file = 'docs/issues_data.json'
        with open(json_file, 'w', encoding='utf-8') as f:
            json.dump(issues_data, f, indent=2, ensure_ascii=False)
        
        print(f"Datos JSON guardados: {json_file}")
        
    except Exception as e:
        print(f"Error: {e}")
        if "rate limit" in str(e).lower() or "403" in str(e):
            print("\nADVERTENCIA: Se alcanzo el limite de rate de la API publica.")
            print("   Para evitar esto, configura un token de GitHub:")
            print("   PowerShell: $env:GITHUB_TOKEN='tu_token'")
            print("   CMD: set GITHUB_TOKEN=tu_token")
            print("   Linux/Mac: export GITHUB_TOKEN=tu_token")
        import traceback
        traceback.print_exc()

if __name__ == '__main__':
    main()

