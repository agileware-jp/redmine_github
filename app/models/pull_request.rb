# frozen_string_literal: true

class PullRequest < ActiveRecord::Base
  belongs_to :issue
  validates :url, presence: true

  def state
    if merged_at.present?
      :merged
    else
      :opened
    end
  end

  def number
    scan_url if @number.nil?
    @number
  end

  def repo_owner
    scan_url if @repo_owner.nil?
    @repo_owner
  end

  def repo_name
    scan_url if @repo_name.nil?
    @repo_name
  end

  def repository
    @repository ||= Repository::Github.find_by(url: "https://github.com/#{repo_owner}/#{repo_name}.git")
  end

  def sync
    return unless repository

    ret = RedmineGithub::GithubAPI.client_by_repository(repository).fetch_pull_request(self)
    return if ret.errors.any? # TODO logging

    update(mergeable_state: ret.data.repository.pull_request.merge_state_status)
  end

  private

  def scan_url
    @repo_owner, @repo_name, @number = url.to_s.scan(/\Ahttps:\/\/github.com\/(.+)\/(.+)\/pull\/(\d+)\z/).flatten
  end
end
