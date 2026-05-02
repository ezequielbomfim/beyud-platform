FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

COPY apps/api/Beyud.Api.csproj apps/api/

RUN dotnet restore apps/api/Beyud.Api.csproj

COPY apps/api/ apps/api/

RUN dotnet publish apps/api/Beyud.Api.csproj \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends libgssapi-krb5-2 \
    && rm -rf /var/lib/apt/lists/*

ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

EXPOSE 8080

COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "Beyud.Api.dll"]