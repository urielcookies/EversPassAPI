# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# Install clang/zlib1g-dev dependencies for publishing to native
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    clang zlib1g-dev
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["EversPassAPI.csproj", "."]
RUN dotnet restore "./EversPassAPI.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./EversPassAPI.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Publish Stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./EversPassAPI.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=true

# Final Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app/publish
EXPOSE 8080
COPY --from=publish /app/publish .
ENTRYPOINT ["./EversPassAPI"]
