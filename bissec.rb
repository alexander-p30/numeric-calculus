# frozen_string_literal: true

require_relative './libs/functions_lib'
require_relative './libs/problems_lib'

function = fetch_function_data
limits, error_margin, maximum_iterations, criterion = fetch_problem_data

stopping_criterion = STOPPING_CRITERIA[criterion]

func_root, iterations, limits = find_approximate_zero({ function: function,
                                                        limits: limits,
                                                        error_margin: error_margin,
                                                        maximum_iterations: maximum_iterations,
                                                        stopping_criterion: stopping_criterion }, :bissection)

display_results(func_root, iterations, limits)
