{% macro logger(log_message, log_level="DEBUG", format='%H:%M:%S') %}
	{{ return(adapter.dispatch("logger")(log_message, log_level=log_level, format=format)) }}
{% endmacro %}

{% macro default__logger(log_message, log_level, format) %}

    {% set log_levels = {
        "DEBUG": 0,
        "INFO": 1,
        "WARNING": 2,
        "ERROR": 3,
        "CRITICAL": 4
    } %}

    {% set setting_level = var("logging_level", "INFO") %}

    {% if not log_level in log_levels.keys() %}
        {% set formatted_keys = log_levels.keys() | list | join(',') %}
        {{ 
            exceptions.raise_compiler_error(
                "Invalid logging level. Got '" ~ level ~ "'. Require one of: '" 
                ~ formatted_keys ~ "'") 
        }}
    {% endif %}
    
    {% set log_bool = log_levels[log_level] >= log_levels[setting_level] %}
    {{ log(modules.datetime.datetime.now().strftime(format) ~ ' | [' ~ log_level ~ '] ' ~ log_message, info=true) }}

{% endmacro %}
