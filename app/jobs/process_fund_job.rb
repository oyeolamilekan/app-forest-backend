class ProcessFundJob < ApplicationJob
  queue_as :default

  def perform(args)
    github_username = args[:github_username]
    product_id = args[:product_id]
    store_slug = args[:store_slug]
    status, product_obj = Products::FetchProduct.call(product_attribute: { public_id: product_id })
    status, repo_name = Utils::RepoLink.shorten(product_obj.repo_link)
    status, github_obj = Integrations::FetchIntegration.call(store_slug: store_slug, provider_id: "github")
    status, add_user = Utils::AddUserToRepo.call(repo: repo_name, username: github_username, permission: "pull", access_token: github_obj.key)      
  end
end
