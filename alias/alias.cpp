#include <cstdlib>
#include <fstream>
#include <iostream>

int global_zsh = 0;
int global_bash = 0;

void	ft_putstr_fd(const char *s, std::ostream &os)
{
	os << s;
}

int	check_alias(void)
{
	const char	*home = getenv("HOME");

	std::ifstream	file(home + std::string("/.zshrc"));
	std::ifstream	file2(home + std::string("/.bashrc"));
	std::string		line;

	if (!file.is_open() && !file2.is_open())
	{
		perror("Error opening the file");
		exit(1);
	}
	while (std::getline(file, line))
	{
		if (line == "alias client=~/Reallyshell/client.sh")
		{
			std::cerr << "Alias already present in the file" << std::endl;
			file.close();
			global_zsh = 1;
			break;
		}
	}
	file.close();
	while (std::getline(file2, line))
	{
		if (line == "alias client=~/Reallyshell/client.sh")
		{
			std::cerr << "Alias already present in the file" << std::endl;
			file2.close();
			global_bash = 1;
			break;
		}
	}
	file2.close();
	return (0);
}

int	main(void)
{
	const char	*home = getenv("HOME");
	char		path[1024];

	if (home == nullptr)
	{
		std::cerr << "Error getting home directory" << std::endl;
		return (1);
	}
	snprintf(path, sizeof(path), "%s/.zshrc", home);
	std::ofstream file(path, std::ios::out | std::ios::app);
	if (!file.is_open())
	{
		perror("Error opening the file");
		return (1);
	}
	else
	{
		if(check_alias() == 1 || global_zsh == 1)
			exit(0);
		ft_putstr_fd("\n", file);
		ft_putstr_fd("alias client=~/Reallyshell/client.sh\n", file);
	}
	file.close();

	sprintf(path, "%s/.bashrc", home);
	std::ofstream file2(path , std::ios::out | std::ios::app);
	if (!file2.is_open())
	{
		perror("Error opening the file");
		return (1);
	}
	else
	{
		if(check_alias() == 1 || global_bash == 1)
			exit(0);
		ft_putstr_fd("\n", file2);
		ft_putstr_fd("alias client=~/Reallyshell/client.sh\n", file2);
	}
	file2.close();
	return (0);
}
