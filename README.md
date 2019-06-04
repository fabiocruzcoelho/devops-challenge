devops-challenge
===============

Role para  realizar as tarefas do devops-challenge serasa, onde o mesmo instala e configura um HTTP Server e faz o deploy de uma simples aplicação em docker.

Requirements
------------

Para o funcionamento, é preciso realizar algumas instalação e/ou configuração na maquina local que ira executar o playbook, click nos links abaixo para maiores informações de como instala cada componente instalação.
 - [virtualbox](https://www.virtualbox.org/wiki/Downloads)
 - [vagrant](https://www.vagrantup.com/intro/getting-started/install.html)
 - [ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
 + chave ssh no path `~/.ssh/id_rsa`
    - Obs:. caso a chave não se encontrar no path acima precisa alterar nos seguintes arquivos.
  - Vagrantfile, linha `69`
  - hosts.yml, linha `8`

Role Variables
--------------

Abaixo segue as variaveis utilizadas na role, as mesmas se encontran em defaults/main.yml

- `docker_image_name:` test
- `docker_image_tag:` v1
- `docker_container_name:` devops-challenge
- `nginx_path_ssl:` /etc/nginx/ssl

Example Playbook
----------------
```yml
- name: devops chanllenge serasa
  hosts: all
  gather_facts: true
  become: yes
  become_user: root
  vars:
    app_name: devops-chanllenge
    git_uri: https://github.com/fcruzcoelho/devops-challenge.git
    code_path: '/home/vagrant/{{ app_name }}'
    branch_name: ansible
  tasks:
    - name: git clone
      git:
        repo: '{{ git_uri }}'
        dest: '{{ code_path }}'
        version: '{{ branch_name}}'
    - name: deploy
      block:
        - name: deploy
          include_role:
            name: ../devops-challenge
          vars:
            docker_image_name: '{{ app_name }}'
            docker_container_name: '{{ app_name }}'
            docker_image_tag: '{{ tag_name }}' '(ex: v1)'
   ```
Preparando ambiente
--------------
Para utilizar o projeto favor executar os comandos abaixo *(Obs:. poderia criar um run.sh mas não deu tempo ;)*
- `git clone https://github.com/fcruzcoelho/devops-challenge.git`
- `vagrant box add ubuntu/bionic64` *(Opcional)*
- `vagrant up` *(na raiz do projeto)*
+ Obs. O servidor é provisionado com endereço IP estatico.
  - IP: `192.168.33.10`
- `vagrant destroy`
  - Destroy ambiente.

Apos a maquina provisionada, executar o playboock com o seguinte comando.
  - `ansible-playbook -i hosts.yml playbook.yml -e 'tag_name=v1'`
  + Obs. A variavel `docker_image_tag` é trocada na execução do playbook via `extra-vars` para realizar o build de uma nova imagem docker, conforme comando acima, e assim uma nova versão da aplicação para deploy.

Acessando aplicação
--------------
Para acessar e testar se a aplicação esta funcionando no seu navegador, favor adicionar em seu arquivo hosts a seguinte linha.
- `sudo echo "192.168.33.10 devops-challenge.serasa.local" >> /etc/hosts`
- `https://devops-challenge.serasa.local`
+ Ou direto via endereço IP `https://192.168.33.10`

Testes
--------------

Os testes são realizados com uma task dentro da propia role, onde Verifica se a página retorna um status 200 e falhe se a palavra `Hey! You win` não está no conteúdo da página

```yml
- name: Verifique se a página retorna um status 200 e falhe se a palavra Hey! You win não está no conteúdo da página
  uri:
    url: 'https://{{ app_domain }}'
    return_content: yes
    validate_certs: no
  register: this
  failed_when: "'Hey! You win' not in this.content"
```

License
-------

BSD

Author
------

Fabio Coelho
