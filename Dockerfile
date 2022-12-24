FROM mcr.microsoft.com/dotnet/runtime:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["ChatBirthdayBot/ChatBirthdayBot.csproj", "ChatBirthdayBot/"]
RUN dotnet restore "ChatBirthdayBot/ChatBirthdayBot.csproj"
COPY . .
WORKDIR "/src/ChatBirthdayBot"
RUN dotnet build "ChatBirthdayBot.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ChatBirthdayBot.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ChatBirthdayBot.dll"]
