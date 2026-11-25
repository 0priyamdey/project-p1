FROM ubuntu:24.04 AS build
RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository -y ppa:dotnet/backports && apt-get update && apt-get install -y dotnet-sdk-10.0 && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY *.csproj ./
RUN dotnet restore
COPY . ./
RUN dotnet publish -c Release -o /app/publish

FROM ubuntu:24.04
RUN apt-get update && apt-get install -y aspnetcore-runtime-8.0 && rm -rf /var/lib/apt/lists/*
ENV ASPNETCORE_URLS="http://+:8080"

WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 8080
ENTRYPOINT ["dotnet", "Foundation.dll"]
