# Copyright (c) 2017, Luc Michalski
# All rights reserved.

MACRO(hunter_regex_cmake)

	IF(NOT __regex_cmake_included)

		SET(__regex_cmake_included true)
		string_codes()

		# ref. http://www.cmake.org/cmake/help/v3.0/manual/cmake-language.7.html#grammar-token-regex_cmake_escape_sequence

		## characters
		SET(regex_cmake_newline "\n")
		SET(regex_cmake_space_chars " \t")
		SET(regex_cmake_space "[${regex_cmake_space_chars}]+")
		SET(regex_cmake_backslash "\\\\")

		## tokens

		# line comment
		SET(regex_cmake_line_comment "#([^${regex_cmake_newline}]*)")
		SET(regex_cmake_line_comment.comment CMAKE_MATCH_1)
		SET(regex_cmake_line_comment_no_group "#([^${regex_cmake_newline}]*)")

		# bracket_comment
		SET(regex_cmake_bracket_comment "#\\[\\[(.*)\\]\\]")
		SET(regex_cmake_bracket_comment_no_group "#${bracket_open_code}${bracket_open_code}.*${bracket_close_code}${bracket_close_code}")

		# identifier
		SET(regex_cmake_identifier "[A-Za-z_][A-Za-z0-9_]*")

		# nesting
		SET(regex_cmake_nesting_start_char "\\(")
		SET(regex_cmake_nesting_end_char "\\)")

		# quoted_argment
		SET(regex_quoted_argument "\"([^\"\\]|([\\][\"])|([\\][\\])|([\\]))*\"")
		SET(regex_quoted_argument_group "\"(([^\"\\]|([\\][\"])|([\\][\\])|([\\]))*)\"")

		# unquoted_argument
		SET(regex_unquoted_argument "[^#\\\\\" \t\n\\(\\)]+")

		## combinations

		# matches every cmake token in a string
		SET(regex_cmake_token "(${regex_cmake_bracket_comment_no_group})|(${regex_cmake_line_comment_no_group})|(${regex_quoted_argument})|${regex_unquoted_argument}|${regex_cmake_space}|${regex_cmake_newline}|${regex_cmake_nesting_start_char}|${regex_cmake_nesting_end_char}")

		SET(regex_cmake_line_ending "(${regex_cmake_line_comment})?(${regex_cmake_newline})")   
		SET(regex_cmake_separation "(${regex_cmake_space})|(${regex_cmake_line_ending})")

		## misc

		# if a value matches this it needs to be put in quotes
		SET(regex_cmake_value_needs_quotes "[ \";\\(\\)]")

		SET(regex_cmake_value_quote_escape_chars "[\\\\\"]")

		SET(regex_cmake_flag "-?-?[A-Za-z_][A-Za-z0-9_\\-]*")
		SET(regex_cmake_double_dash_flag "\\-\\-[a-zA-Z0-9][a-zA-Z0-9\\-]*")
		SET(regex_cmake_single_dash_flag "\\-[a-zA-Z0-9][a-zA-Z0-9\\-]*")

		## todo: quoted, unquoated, etc
		SET(regex_cmake_argument_string ".*")
		SET(regex_cmake_command_invocation "(${regex_cmake_space})*(${regex_cmake_identifier})(${regex_cmake_space})*\\((${regex_cmake_argument_string})\\)")
		SET(regex_cmake_command_invocation.regex_cmake_identifier CMAKE_MATCH_2)
		SET(regex_cmake_command_invocation.arguments CMAKE_MATCH_4)

		SET(regex_cmake_function_begin "(^|${cmake_regex_newline})(${regex_cmake_space})?function(${regex_cmake_space})?\\([^\\)\\(]*\\)")
		SET(regex_cmake_function_end   "(^|${cmake_regex_newline})(${regex_cmake_space})?endfunction(${regex_cmake_space})?\\(([^\\)\\(]*)\\)")
		SET(regex_cmake_function_signature "(^|${cmake_regex_newline})((${regex_cmake_space})?)(${regex_cmake_identifier})((${regex_cmake_space})?)\\([${regex_cmake_space_chars}${regex_cmake_newline}]*(${regex_cmake_identifier})(.*)\\)")
		SET(regex_cmake_function_signature.name CMAKE_MATCH_7)
		SET(regex_cmake_function_signature.args CMAKE_MATCH_8)

	ENDIF()
  
ENDMACRO()
