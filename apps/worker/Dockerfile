FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

COPY apps/worker/Beyud.Worker.csproj apps/worker/

RUN dotnet restore apps/worker/Beyud.Worker.csproj

COPY apps/worker/ apps/worker/

RUN dotnet publish apps/worker/Beyud.Worker.csproj \
    -c Release \
    -o /app/publish \
    /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/runtime:8.0 AS runtime

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends libgssapi-krb5-2 \
    && rm -rf /var/lib/apt/lists/*

ENV DOTNET_ENVIRONMENT=Production

COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "Beyud.Worker.dll"]