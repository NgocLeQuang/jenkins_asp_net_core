 FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
 WORKDIR /app
 EXPOSE 80
 FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
 WORKDIR /src
 COPY ["jenkins_asp_net_core/jenkins_asp_net_core.csproj", ""]
 RUN dotnet restore "./jenkins_asp_net_core.csproj"
 COPY "jenkins_asp_net_core/." .
 WORKDIR "/src/."
 RUN dotnet build "jenkins_asp_net_core.csproj" -c Release -o /app/build
 FROM build AS publish
 RUN dotnet publish "jenkins_asp_net_core.csproj" -c Release -o /app/publish
 FROM base AS final
 WORKDIR /app
 COPY --from=publish /app/publish .
 ENTRYPOINT ["dotnet", "jenkins_asp_net_core.dll"]
