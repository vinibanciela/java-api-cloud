# Etapa de build com Gradle e JDK 21 
FROM gradle:jdk21-graal AS BUILD
WORKDIR /usr/app
COPY . .

# Compila a aplicação (sem usar o daemon)
RUN gradle build --no-daemon

# Etapa final de execução com JDK enxuto
FROM openjdk:21-jdk-slim
WORKDIR /app 

# Cria usuário sem privilégios administrativos
RUN useradd -ms /bin/bash appuser

# Copia o .jar gerado (usa wildcard para flexibilidade)
COPY --from=BUILD /usr/app/build/libs/*.jar app.jar

# Define que a aplicação será executada como usuário comum
USER appuser

# Expõe a porta da API
EXPOSE 8080

# Comando para iniciar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
