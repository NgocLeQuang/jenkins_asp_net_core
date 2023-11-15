#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["jenkins_asp_net_core/jenkins_asp_net_core.csproj", "jenkins_asp_net_core/"]
RUN dotnet restore "jenkins_asp_net_core/jenkins_asp_net_core.csproj"
COPY . .
WORKDIR "/src/jenkins_asp_net_core"
RUN dotnet build "jenkins_asp_net_core.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "jenkins_asp_net_core.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "jenkins_asp_net_core.dll"]